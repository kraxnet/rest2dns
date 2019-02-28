require 'logger'

module CONF
  LOG_FILE = STDOUT

  DNS_SERVER_TYPE = :knot
  # DNS_SERVER_TYPE = :bind

  module KNOT
    ZONE_FILE_DIR = 'zones/knot'.freeze
    ZONE_FILE_SUFFIX = '.zone'.freeze
    ZONE_FILE_LIST = 'zones/knot-zones.conf'.freeze
    DOMAIN_TEMPLATE_NAME = 'syncdns'.freeze
    COMMAND_RELOAD = 'knotc reload'.freeze
    COMMAND_CHECKZONE = 'kzonecheck'.freeze
  end
end

$log = Logger.new(CONF::LOG_FILE)
$log.formatter = Logger::Formatter.new
$log.level = Logger::DEBUG
