#!/usr/bin/env ruby

# o remove entries with no time spans.

require 'rubygems'
require 'yaml'
require './perishable.rb'


foods = []

db_size = 0
File.open('db.yaml') do |yf|
  YAML.load_documents(yf) do |ydoc|
    db_size += 1
    s = ydoc.split
    foods << s
  end
end
 
foods.compact!
foods.flatten!
foods.each {|f| puts f }
puts "dbsize=" + db_size.to_s

File.open("db-split.yaml", "w+") do |f|
  foods.each {|s| YAML.dump(s, f) }
end
