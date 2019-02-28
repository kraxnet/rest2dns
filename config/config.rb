require 'logger'

module CONF
  LOG_FILE = STDOUT

  DNS_SERVER_TYPE = :knot
  # DNS_SERVER_TYPE = :bind

  module KNOT

    ZONE_FILE_DIR = "zones/knot"
    ZONE_FILE_SUFFIX = ".zone"
    ZONE_FILE_LIST = "zones/knot-zones.conf"
    DOMAIN_TEMPLATE_NAME = "syncdns"
    COMMAND_RELOAD = "knotc reload"
    COMMAND_CHECKZONE = "kzonecheck"

  end

end

$log = Logger.new(CONF::LOG_FILE)
$log.formatter = Logger::Formatter.new
$log.level = Logger::DEBUG
