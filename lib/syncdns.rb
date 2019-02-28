require_relative 'knot'

class SyncDNS

  def self.setup_zone(zones, content)
    if CONF::DNS_SERVER_TYPE == :knot
      knot_sync_dns = KnotSyncDNS.new
      zones.each { |zone| knot_sync_dns.setup_zone(zone,content) }
      return knot_sync_dns.save_and_reload
    end
  end

  def self.destroy_zone(zones)
    if CONF::DNS_SERVER_TYPE == :knot
      knot_sync_dns = KnotSyncDNS.new
      zones.each { |zone| knot_sync_dns.destroy_zone(zone) }
      return knot_sync_dns.save_and_reload
    end
  end

end
