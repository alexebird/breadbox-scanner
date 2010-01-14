require 'logger'

require '../db/init'
FoodDB.connect

module ScanServer

  class << self
    @@logger = Logger.new(STDOUT)
    @@logger.level = Logger::DEBUG

    def logger=(logger)
      @@logger = logger
    end

    def logger
      @@logger
    end
  end
end
