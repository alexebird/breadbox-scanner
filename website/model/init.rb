# Here goes your database connection and options:
require 'sequel'

Sequel::Model.plugin(:schema)
DB = Sequel.sqlite('food.db')

# Here go your requires for models:
require 'model/food'
