require 'logger'

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

    def time_ago_in_words(time)
      mins = (Time.now.to_i - time.to_i) / 60.0
      mins = mins.round
      case mins
        when 0..1 then "a minute ago"
        when 2..45 then "#{mins} minutes ago"
        when 46...90 then "1 hour ago"
        when 90..1380 then "#{(mins / 60.0).round} hours ago"
        when 1381..2160 then "1 day ago"
        when 2161..8640 then "#{(mins / (60 * 24.0)).round} days ago"
        when 8641..15120 then "1 week ago"
        when 15121..40320 then "#{(mins / (60 * 24 * 7.0)).round} weeks ago"
        when 40321..65700 then "1 month ago"
        when 65701..481800 then "#{(mins / (60 * 24 * 30.42)).round} months ago"
        when 481801..788000 then "1 year ago"
        else "#{(mins / (60 * 24 * 365.0)).round} years ago"
      end
    end
  end
end
