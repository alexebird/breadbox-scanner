#!/usr/bin/env ruby

require 'rubygems'
require 'serialport'
require 'optparse'
require 'ostruct'

options = OpenStruct.new
options.port = 0
OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on("-p PORT", Integer, "Serial port (i.e. /dev/ttyUSB0)") do |v|
    options.port = v
  end
end.parse!

port = '/dev/ttyUSB' + options.port.to_s

SerialPort.open(port, 2400, 8, 1 , SerialPort::NONE) do |sp|
  loop do
    while (i = sp.gets)
      print i
    end
  end
end
