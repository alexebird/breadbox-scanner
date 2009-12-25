#!/usr/bin/env ruby

# o convert 12 months to 1 year
# o all lowercase
#
require 'rubygems'
require 'yaml'
require 'sequel'
require 'food'

foods = []

File.open('db-final.yaml') do |yf|
  YAML.load_documents(yf) do |ydoc|
    foods << ydoc
  end
end


DB = Sequel.sqlite("food.db")

# create an items table
DB.create_table :foods do
  primary_key :id
  String :name
  String :rfid
  String :major
  String :minor
  Fixnum :room_start 
  Fixnum :room_end
  Fixnum :fridge_start 
  Fixnum :fridge_end
  Fixnum :freezer_start 
  Fixnum :freezer_end
end unless DB.table_exists?(:foods)

# create a dataset from the items table
foods_ds = DB[:foods]

# populate the table
foods.each {|f|
  foods_ds.insert(:name => f.name, :rfid => f.rfid,
                  :major => f.major.to_s, :minor => f.minor.to_s,
                  :room_start => f.room_start, :room_end => f.room_end,
                  :fridge_start => f.fridge_start, :fridge_end => f.fridge_end,
                  :freezer_start => f.freezer_start, :freezer_end => f.freezer_end)
}
