ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../../config/config.rb', __FILE__
require File.expand_path '../../bin/syncdns-srv.rb', __FILE__
