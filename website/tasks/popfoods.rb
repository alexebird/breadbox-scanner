#!/usr/bin/env ruby

# o convert 12 months to 1 year
# o all lowercase
#
require 'rubygems'
require 'yaml'
require 'sequel'

class Food
  attr_accessor :name, :rfid,
                :major, :minor,
                :room_start, :room_end,
                :fridge_start, :fridge_end,
                :freezer_start, :freezer_end
end

DB = Sequel.sqlite("food.db")

unless DB.table_exists?(:foods)
  puts "foods table doesn't exist."
  exit
end

# create a dataset from the items table
foods_ds = DB[:foods]
foods_ds.delete

i = 0
File.open('db.yaml') do |file|
  YAML.load_documents(file) do |f|
    foods_ds.insert(:name => f.name, :rfid => f.rfid,
                    :major => f.major.to_s, :minor => f.minor.to_s,
                    :room_start => f.room_start, :room_end => f.room_end,
                    :fridge_start => f.fridge_start, :fridge_end => f.fridge_end,
                    :freezer_start => f.freezer_start, :freezer_end => f.freezer_end)
  end
end
