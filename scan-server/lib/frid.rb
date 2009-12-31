require 'logger'
require 'socket'

module Frid

  class << self
    @@logger = Logger.new(STDOUT)

    def logger
      @@logger
    end

    def log_level=(level)
      @@logger.level = level
    end

    def logger=(logger, level=Logger::INFO)
      @@logger = logger
      @@logger.level = level
    end
  end

  #def Frid.send_arduino(cmd)
    #host, port = 'localhost', 5248
    #TCPSocket.open(host, port) do |s|
      #puts " sending: #{cmd}"
      #s.puts cmd
      #while line = s.gets
        #line.chomp!
        #puts "response: #{line}"
      #end
    #end
  #end
end
