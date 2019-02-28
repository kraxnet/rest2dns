require 'yaml'
require 'tempfile'

class KnotSyncDNS

  @zone_list_conf = {}
  @zone_list_changed = false

  def initialize
    @zone_list_conf = read_zone_list
  end

  def list_zones
    @zone_list_conf["zone"].collect { |z| z["domain"] }
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
    return reload
  end

  private

  def save
    File.open(CONF::KNOT::ZONE_FILE_LIST, "w") { |f| f.puts(@zone_list_conf.to_yaml.sub(/^---\n/,'')) } if @zone_list_changed
  end

  def reload
    begin
      output = %x( #{CONF::KNOT::COMMAND_RELOAD} )
    rescue => err
      output = err.to_s
    end
    process_status = $?
    return [output, process_status]
  end

  def read_zone_list
    return File.exists?(CONF::KNOT::ZONE_FILE_LIST) ? YAML.load_file(CONF::KNOT::ZONE_FILE_LIST) : { "zone" => [] }
  end

  def add_zone_to_list(zone)
    unless @zone_list_conf["zone"].detect { |z| z["domain"] == zone }
      @zone_list_conf["zone"] << { "domain" => zone, "template" => CONF::KNOT::DOMAIN_TEMPLATE_NAME }
      @zone_list_changed = true
    end
  end

  def remove_zone_from_list(zone)
    count_before = @zone_list_conf["zone"].count
    @zone_list_conf["zone"].reject! { |z| z["domain"] == zone }
    @zone_list_changed = true unless count_before == @zone_list_conf["zone"].count
  end

  def store_zone_file(zone, content)
    File.open(File.join(CONF::KNOT::ZONE_FILE_DIR, zone + CONF::KNOT::ZONE_FILE_SUFFIX), "w") { |f| f.puts(content) }
  end

  def destroy_zone_file(zone)
    File.delete(File.join(CONF::KNOT::ZONE_FILE_DIR, zone + CONF::KNOT::ZONE_FILE_SUFFIX)) if File.exists?(File.join(CONF::KNOT::ZONE_FILE_DIR, zone + CONF::KNOT::ZONE_FILE_SUFFIX))
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
    tmpfile = Tempfile.new("syncdns")
    tmpfile.write(@zone_content)
    tmpfile.close
    result = check_zonefile(@zone_name, tmpfile.path)
    tmpfile.unlink
    return result
  end

  private
  def check_zonefile(zonename, filename)
    begin
      output = `#{CONF::KNOT::COMMAND_CHECKZONE} -v -o #{zonename} #{filename} 2>&1`
    rescue => err
      output = err.to_s
    end
    process_status = $?
    return [{ :full_output => output }, process_status] if process_status.success? # no errors

    result = { :full_output => output, :errors => []}
    output.each_line do |line|
      line = line.chomp!
      case line
      when /^$/ then next
      when /^\s/ then next
      when /^Failed to run semantic checks/ then next
      when /^Serious semantic error detected/ then next
      when /^Error summary:$/ then next
      when /^error:/
        error = {:text => line}

        m = /line (\d+)/.match(line)
        error[:lineno] = m[1] if m && m[1]

        m = /\(([^\)]*)\)/.match(line)
        error[:type] = m[1] if m && m[1]

        result[:errors] << error
      when /^\[/
        error = {:text => line}

        m = /\[([^\]].*)\]\s(.*)/.match(line)
        if m && m[2]
          error[:type] = m[2]
        else
          error[:type] = line
        end
        result[:errors] << error
      else
        $log.error "unknown line: #{line}"
      end
    end
    return [result, process_status]
  end

end
