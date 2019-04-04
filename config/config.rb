# frozen_string_literal: true

require 'logger'

module CONF
  LOG_FILE = STDOUT

  DNS_SERVER_TYPE = :knot
  # DNS_SERVER_TYPE = :bind

  # 1 = master. 0 = slave
  DNS_SERVER_MASTER = (ENV['DNS_MASTER_SERVER'] || 1).to_s == "1"

  module KNOT
    ZONE_FILE_DIR = ENV['KNOT_ZONE_FILE_DIR'] || '/etc/knot/zones'
    ZONE_FILE_SUFFIX = ENV['KNOT_ZONE_FILE_SUFFIX'] || '.zone'
    ZONE_FILE_LIST = ENV['KNOT_ZONE_FILE_LIST'] || '/etc/knot/knot-zones.conf'
    DOMAIN_TEMPLATE_NAME =  ENV['DOMAIN_TEMPLATE_NAME'] || 'rest2dns'
    COMMAND_RELOAD =  ENV['KNOT_COMMAND_RELOAD'] || 'knotc reload'
    COMMAND_CHECKZONE = ENV['KNOT_COMMAND_CHECKZONE'] || 'kzonecheck'
  end
end

$log = Logger.new(CONF::LOG_FILE)
$log.formatter = Logger::Formatter.new
$log.level = Logger::DEBUG
