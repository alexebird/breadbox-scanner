# Here goes your database connection and options:
require 'sequel'

DB_ROOT = File.expand_path(File.dirname(__FILE__))

DB = Sequel.connect("sqlite://#{DB_ROOT}/food.db")

require DB_ROOT + '/model/food'
require DB_ROOT + '/model/user'
