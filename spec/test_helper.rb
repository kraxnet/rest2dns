ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../../config/config.rb', __FILE__
require File.expand_path '../../bin/rest2dns.rb', __FILE__

module CONF
  module KNOT
    warn_level = $VERBOSE
    $VERBOSE = nil
    ZONE_FILE_DIR = 'spec/zones/knot'.freeze
    ZONE_FILE_SUFFIX = '.zone'.freeze
    ZONE_FILE_LIST = 'spec/zones/knot-zones.conf'.freeze
    $VERBOSE = warn_level
  end
end
