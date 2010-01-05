module ScanServer
  class Request
    SCAN = 1
    INVENTORY = 2

    attr_reader :type, :user_id, :options, :conn

    def initialize(conn)
      @conn = conn
      req_str = @conn.gets 
      if Request.validate(req_str)
        args = req_str.chomp.split(/\s+/)
        @type = args.shift.to_i
        @user_id = args.shift.to_i
        @options = args
        debug self.to_s
      else
        err = "Empty request."
        warn err
        raise err
      end
    end

    def to_s
      "<Request: type=#@type user_id=#@user_id options=#@options>"
    end

    private

    class << self
      def validate(req_str)
        # TODO validate request string
        req_str
      end
    end
  end
end
