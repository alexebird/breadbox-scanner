# Here goes the database connection and options:
require 'sequel'
require 'logger'
DB_ROOT = File.expand_path(File.dirname(__FILE__))
DB = Sequel.connect("sqlite://#{DB_ROOT}/food.db")
DB.loggers << Logger.new(STDOUT)

# Here go the required models:
require DB_ROOT + '/model/food'
require DB_ROOT + '/model/user'
require DB_ROOT + '/model/scan'
