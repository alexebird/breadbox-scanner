require 'socket'
require 'scan_server'
require 'scan-server/servlet_dispatcher'
require 'scan-server/request'

module ScanServer
  class Server
    def initialize(host='0.0.0.0', port=7001)
      @host = host
      @port = port
      @dispatcher = ServletDispatcher.new
      @server = TCPServer.new(@host, @port)
      info "Listening on #@host:#@port."
      init_traps
    end

    def init_traps
      # Shutdown gracefully on INT or TERM signals.
      # - INT usually comes from Ctrl-C in a console.
      # - TERM usually comes from using kill, pkill, etc.
      sd = Proc.new { self.shutdown }
      trap("INT", sd)
      trap("TERM", sd)
    end

    def shutdown
      info "Shutting down."
      @server.close
      exit
    end

    def start 
      info "Starting"
      loop do
        begin
          info "Waiting for connection."
          client = @server.accept
          request = Request.new(client)
          @dispatcher.dispatch(request)
        rescue IOError => e
          error "TCPServer-related error: " + e.message
        rescue RuntimeError => e
          error e.message
        ensure
          client.close unless !client or client.closed?
        end
      end
    end
  end
end
