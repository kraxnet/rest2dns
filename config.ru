# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.setup

require_relative 'config/config.rb'
require 'rest2dns'

run Rest2DnsApp
