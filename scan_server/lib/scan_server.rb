require 'logger'

require '../db/init'
FoodDB.connect
FoodDB.load_models

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

    def time_diff_in_words(start, fin)
      mins = (fin.to_i - start.to_i) / 60.0
      mins = mins.round
      case mins
        when 0..1 then "a minute"
        when 2..45 then "#{mins} minutes"
        when 46...90 then "1 hour"
        when 90..1380 then "#{(mins / 60.0).round} hours"
        when 1381..2160 then "1 day"
        when 2161..8640 then "#{(mins / (60 * 24.0)).round} days"
        when 8641..15120 then "1 week"
        when 15121..40320 then "#{(mins / (60 * 24 * 7.0)).round} weeks"
        when 40321..65700 then "1 month"
        when 65701..481800 then "#{(mins / (60 * 24 * 30.42)).round} months"
        when 481801..788000 then "1 year"
        else "#{(mins / (60 * 24 * 365.0)).round} years"
      end
    end

    def time_ago_in_words(time)
      time_diff_in_words(time, Time.now) + " ago"
    end
  end
end
