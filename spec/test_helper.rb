# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../config/config.rb', __dir__
require File.expand_path '../bin/rest2dns.rb', __dir__

module CONF
  module KNOT
    warn_level = $VERBOSE
    $VERBOSE = nil
    ZONE_FILE_DIR = 'spec/zones/knot'
    ZONE_FILE_SUFFIX = '.zone'
    ZONE_FILE_LIST = 'spec/zones/knot-zones.conf'
    $VERBOSE = warn_level
  end
end
