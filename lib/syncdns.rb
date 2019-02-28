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

  def self.check_zone(zone, content)
    if CONF::DNS_SERVER_TYPE == :knot
      knot_dns_check = KnotZoneCheck.new(zone, content)
      result = knot_dns_check.check
      if result.last.success?
        return [result.first[:full_output], result.last]
      else
        return [
          # select only errors with linenumber
          {:errors => result.first[:errors].collect { |err| next if err[:lineno].nil?
            {:line => err[:lineno].to_i, :text => err[:type] }
          }.compact },
          result.last]
      end
      return result
    end
  end

end
