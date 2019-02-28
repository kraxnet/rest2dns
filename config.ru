require 'rubygems'
require 'bundler'
Bundler.setup

require_relative 'config/config.rb'

require 'sinatra'
require 'erb'
require 'yaml'

require_relative 'bin/syncdns-srv.rb'

run Sinatra::Application
