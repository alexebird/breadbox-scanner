#!/usr/bin/env ruby

require 'perishable'

class Food
  attr_accessor :name, :rfid,
                :major, :minor,
                :room_start, :room_end,
                :fridge_start, :fridge_end,
                :freezer_start, :freezer_end

  def initialize(perishable)
    @major = perishable.major
    @minor = perishable.minor
    @name = perishable.name

    if perishable.room
      if perishable.room.class == Range
        @room_start = perishable.room.first
        @room_end = perishable.room.last
      elsif perishable.room.kind_of? Fixnum
        @room_start = perishable.room
      else
        puts "panic: room type"
      end
    end

    if perishable.fridge
      if perishable.fridge.class == Range
        @fridge_start = perishable.fridge.first
        @fridge_end = perishable.fridge.last
      elsif perishable.fridge.kind_of? Fixnum
        @fridge_start = perishable.fridge
      else
        puts "panic: fridge type"
      end
    end

    if perishable.freezer
      if perishable.freezer.class == Range
        @freezer_start = perishable.freezer.first
        @freezer_end = perishable.freezer.last
      elsif perishable.freezer.kind_of? Fixnum
        @freezer_start = perishable.freezer
      else
        puts "panic: freezer type"
      end
    end
  end

  def to_s
      "#@name (#@major#{', ' + @minor.to_s if @minor})#{Food.time_to_s("room", @room_start, @room_end)}#{Food.time_to_s("fridge", @fridge_start, @fridge_end)}#{Food.time_to_s("freezer", @freezer_start, @freezer_end)}"
  end

  private 
  def Food.time_to_s(desc, time_start, time_end)
    return '' unless time_start
    " #{desc}: #{time_start}#{' to ' + time_end.to_s if time_end} days"
  end

end
