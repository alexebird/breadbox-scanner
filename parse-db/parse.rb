#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'
require 'hpricot'
require './perishable.rb'

# From http://whatscookingamerica.net/Information/FreezerChart.htm
url = "chart.htm"
hp = Hpricot::XML(open(url))
table = hp.search("#table2")
rows = table.search("tr")
norm = Proc.new {|s| s.strip.gsub(/\t|\n|\r|\240|\302/, "").squeeze(' ') }
major = nil
minor = nil
foods = []

rows.each do |r|
  next if norm.call(r.inner_text).empty?

  txt = r.search("td").attr("bgcolor")
  if txt == "#FFFFD9"
    major = norm.call(r.inner_text)
    #puts "Major: #{major}"
  elsif txt == "#cccccc" or txt == "#C0C0C0"
    minor = norm.call(r.inner_text)
    #puts "Minor: #{minor}"
  elsif r.search("td").text.match(/.*room.temperature.*refrigerator.*freezer.*comments.*/im) == nil # skip col headers
    #puts "Food:        " + norm.call(r.at("td[1]").inner_text)
    #puts "  room temp: " + norm.call(r.at("td[2]").inner_text)
    #puts "  fridge:    " + norm.call(r.at("td[3]").inner_text)
    #puts "  freezer:   " + norm.call(r.at("td[4]").inner_text)

    food = Perishable.new(major, minor)
    food.name = norm.call(r.at("td[1]").inner_text)
    food.room = norm.call(r.at("td[2]").inner_text)
    food.fridge = norm.call(r.at("td[3]").inner_text)
    food.freezer = norm.call(r.at("td[4]").inner_text)
    foods << food
  end
end

#File.open("db.yaml", "w+") do |f|
  #foods.each {|s| YAML.dump(s, f) }
#end
