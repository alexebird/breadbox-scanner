module ScanServer
  class Request
    SCAN = 10
    INVENTORY = 20

    attr_reader :type, :user_id, :options, :conn, :peeraddr

    def initialize(conn)
      @conn = conn
      @peeraddr = "#{@conn.peeraddr[3]}:#{@conn.peeraddr[1]}"
      req_str = @conn.gets 
      if Request.validate(req_str)
        args = req_str.chomp.split(/\s+/)
        @type = args.shift.to_i
        @user_id = args.shift.to_i
        @options = args
      else
        err = "Empty request."
        warn err
        raise err
      end
    end

    def to_s
      "<Request: host=#@peeraddr type=#@type user_id=#@user_id options=#@options>"
    end

    def is_scan?
      return @type == SCAN
    end

    def is_inventory?
      return @type == INVENTORY
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
