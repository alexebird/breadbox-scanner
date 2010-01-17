# This file contains your application, it requires dependencies and necessary
# parts of the application.
#
# It will be required from either `config.ru` or `start.rb`

require 'rubygems'
require 'ramaze'

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [__DIR__]
Ramaze::Log.level = Logger::INFO

require File.join(File.dirname(__FILE__), '../db/init')
FoodDB.connect#:log_to_console => true

require __DIR__('controller/init')
