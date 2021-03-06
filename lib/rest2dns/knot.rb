# frozen_string_literal: true

require 'yaml'
require 'tempfile'

class KnotSyncDNS
  def initialize
    read_zone_list
    @zone_list_changed = false
  end

  def list_zones
    @zone_list_conf['zone'].collect { |z| z['domain'] }
  end

  def setup_zone(zone, content)
    add_zone_to_list(zone)
    store_zone_file(zone, content)
  end

  def destroy_zone(zone)
    remove_zone_from_list(zone)
    destroy_zone_file(zone)
  end

  def save_and_reload
    save
    reload
  end

  private

  def save
    File.open(CONF::KNOT::ZONE_FILE_LIST, 'w') { |f| f.puts(@zone_list_conf.to_yaml.sub(/^---\n/, '')) } if @zone_list_changed
  end

  def reload
    begin
      output = `#{CONF::KNOT::COMMAND_RELOAD}`
    rescue StandardError => err
      output = err.to_s
    end
    process_status = $?
    [output, process_status]
  end

  def read_zone_list
    @zone_list_conf = File.exist?(CONF::KNOT::ZONE_FILE_LIST) ? YAML.load_file(CONF::KNOT::ZONE_FILE_LIST) : { 'zone' => [] }
    if @zone_list_conf == false
      @zone_list_conf = { 'zone' => [] }
    elsif @zone_list_conf["zone"].nil?
      @zone_list_conf["zone"] = []
    end
    @zone_list_conf
  end

  def add_zone_to_list(zone)
    unless @zone_list_conf['zone'].detect { |z| z['domain'] == zone }
      @zone_list_conf['zone'] << { 'domain' => zone, 'template' => CONF::KNOT::DOMAIN_TEMPLATE_NAME }
      @zone_list_changed = true
    end
  end

  def remove_zone_from_list(zone)
    count_before = @zone_list_conf['zone'].count
    @zone_list_conf['zone'].reject! { |z| z['domain'] == zone }
    @zone_list_changed = true unless count_before == @zone_list_conf['zone'].count
  end

  def store_zone_file(zone, content)
    File.open(File.join(CONF::KNOT::ZONE_FILE_DIR, zone + CONF::KNOT::ZONE_FILE_SUFFIX), 'w') { |f| f.puts(content) }
  end

  def destroy_zone_file(zone)
    File.delete(File.join(CONF::KNOT::ZONE_FILE_DIR, zone + CONF::KNOT::ZONE_FILE_SUFFIX)) if File.exist?(File.join(CONF::KNOT::ZONE_FILE_DIR, zone + CONF::KNOT::ZONE_FILE_SUFFIX))
  end
end

class KnotZoneCheck
  @zone_name = nil
  @zone_content = nil

  def initialize(zone_name, zone_content)
    @zone_name = zone_name
    @zone_content = zone_content
  end

  def check
    tmpfile = Tempfile.new('syncdns')
    tmpfile.write(@zone_content)
    tmpfile.close
    result = check_zonefile(@zone_name, tmpfile.path)
    tmpfile.unlink
    result
  end

  private

  def check_zonefile(zonename, filename)
    begin
      output = `#{CONF::KNOT::COMMAND_CHECKZONE} -v -o #{zonename} #{filename} 2>&1`
    rescue StandardError => err
      output = err.to_s
    end
    process_status = $?
    return [{ full_output: output }, process_status] if process_status.success? # no errors

    result = { full_output: output, errors: [] }
    output.each_line do |line|
      line = line.chomp!
      case line
      when /^$/ then next
      when /^\s/ then next
      when /^Failed to run semantic checks/ then next
      when /^Serious semantic error detected/ then next
      when /^Error summary:$/ then next
      when /^error:/
        error = { text: line }

        m = /line (\d+)/.match(line)
        error[:lineno] = m[1] if m && m[1]

        m = /\(([^\)]*)\)/.match(line)
        error[:type] = m[1] if m && m[1]

        result[:errors] << error
      when /^\[/
        error = { text: line }

        m = /\[([^\]].*)\]\s(.*)/.match(line)
        error[:type] = if m && m[2]
                         m[2]
                       else
                         line
                       end
        result[:errors] << error
      else
        $log.error "unknown line: #{line}"
      end
    end
    [result, process_status]
  end
end
