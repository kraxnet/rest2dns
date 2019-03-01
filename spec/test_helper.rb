# frozen_string_literal: true

require 'bundler/setup'

ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../config/config.rb', __dir__
require 'rest2dns'

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
