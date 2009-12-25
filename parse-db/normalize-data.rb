#!/usr/bin/env ruby

# o convert 12 months to 1 year
# o all lowercase
#
require 'rubygems'
require 'yaml'
require './perishable.rb'

foods = []

File.open('db.yaml') do |yf|
  YAML.load_documents(yf) do |ydoc|
    ydoc.normalize
    foods << ydoc
  end
end

foods.each {|f| puts f }

File.open("db-norm.yaml", "w+") do |f|
  foods.each {|s| YAML.dump(s, f) }
end
