require 'yaml'

class KnotSyncDNS

  @zone_list_conf = {}
  @zone_list_changed = false

  def initialize
    @zone_list_conf = read_zone_list
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
      output = %x( #{CONF::KNOT::RELOAD_COMMAND} )
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
