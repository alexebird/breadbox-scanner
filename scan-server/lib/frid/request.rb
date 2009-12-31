module Frid
  class Request
    attr_reader :user_id, :rfid, :conn

    def initialize(conn)
      @conn = conn
      req_str = @conn.gets 
      if req_str
        args = req_str.chomp.split(/\s+/)
        @user_id = args.first.to_i
        @rfid = args.last
        debug self.to_s
      else
        err = "Empty request."
        warn err
        raise err
      end
    end

    def to_s
      "<Request: user_id=#@user_id rfid=#@rfid>"
    end

    def puts(data)
      @conn.puts data
    end
  end
end
