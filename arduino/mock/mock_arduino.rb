#!/usr/bin/ruby

require "socket"

host, port = "localhost", 7001
puts "Starting mock arduino.",
     "Talking to #{host}:#{port}."

TCPSocket.open(host, port) do |s|
  cmd = "1 36008B60F7"
  puts "Sending RFID: #{cmd}"
  s.puts cmd
end
