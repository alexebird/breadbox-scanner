module Frid
  class FridServer
    def initialize(host='0.0.0.0', port=7001)
      @host = host
      @port = port
      @dispatcher = ServletDispatcher.new
      Frid.logger.info "Listening on #@host:#@port."

      # Shutdown gracefully on INT or TERM signals.
      # o INT usually comes from Ctrl-C in a console.
      # o TERM usually comes from using kill, pkill, etc.
      sd = Proc.new { self.shutdown }
      trap("INT", sd)
      trap("TERM", sd)
    end

    def shutdown
      Frid.logger.info "Shutting down."
      @server.close
      exit
    end

    def start 
      Frid.logger.info "Starting"
      @server = TCPServer.new(@host, @port)
      loop do
        begin
          Frid.logger.info "Waiting for connection."
          client = @server.accept
          request = Request.new(client)
          @dispatcher.dispatch(request)
        rescue IOError => e
          Frid.logger.error "TCPServer-related error: " + e.message
        rescue RuntimeError => e
          Frid.logger.error e.message
        ensure
          client.close unless !client or client.closed?
        end
      end
    end
  end

  class Request
    attr_reader :user_id, :rfid

    def initialize(conn)
      #@conn = conn
      req_str = conn.gets 
      if req_str
        args = req_str.chomp.split(/\s+/)
        @user_id = args.first.to_i
        @rfid = args.last
        Frid.logger.debug self.to_s
      else
        err = "Empty request."
        raise err
        Frid.logger.info err
      end
    end

    def to_s
      "<Request: user_id=#@user_id rfid=#@rfid>"
    end

    #def puts(data)
      #@conn.puts data
    #end
  end
end
