APP_ROOT = File.dirname(__FILE__)

require 'rubygems'
require "#{APP_ROOT}/lib/frid"
require "#{APP_ROOT}/lib/frid_server"
require "#{APP_ROOT}/lib/servlet_dispatcher"
require "#{APP_ROOT}/lib/servlet"

#Frid.logger = Logger.new("#{APP_ROOT}/frid.log")
Frid.log_level = Logger::DEBUG
frid = Frid::FridServer.new
frid.start
