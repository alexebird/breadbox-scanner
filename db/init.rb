# Here goes the database connection and options:
require 'rubygems'
require 'sequel'
require 'logger'

DB_ROOT = File.expand_path(File.dirname(__FILE__))

if ENV['db_env'].empty?
  ENV['db_env'] = "development"
end

db = "#{ENV['db_env']}.db"
puts "Using #{db} as database."
DB = Sequel.connect("sqlite://#{DB_ROOT}/#{db}")
unless ENV['db_env'] == 'test'
  DB.loggers << Logger.new(STDOUT)
end

# Here go the required models:
require DB_ROOT + '/model/food'
require DB_ROOT + '/model/user'
require DB_ROOT + '/model/scan'
require DB_ROOT + '/model/scanner'
