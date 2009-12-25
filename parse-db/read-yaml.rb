#!/usr/bin/env ruby

# o remove entries with no time spans.

require 'rubygems'
require 'yaml'
require 'perishable'
require 'food'


foods = []

File.open('db-norm.yaml') do |yf|
  YAML.load_documents(yf) do |ydoc|
    s = ydoc.split
    foods << s
  end
end
 
foods.compact!
foods.flatten!

File.open("db-final.yaml", "w+") do |f|
  foods.each {|s| YAML.dump(Food.new(s), f) }
end
