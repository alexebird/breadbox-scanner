module ScanServer

  # === Request Format
  # * Request tokens are separated by spaces.
  # * Request type and the id of the sending scanner are always sent as the first two tokens.
  # * Format:
  # * <tt>type scanner_id [options...]</tt>
  #
  module Request
    SCAN = 10
    INVENTORY = 20

    attr_reader :scanner_id, :peeraddr, :socket

    private
    def initialize(socket, opts)
      @socket = socket
      @peeraddr = "#{@socket.peeraddr[3]}:#{@socket.peeraddr[1]}"
      @scanner_id = opts[1].to_i
      @opts = opts
    end

    public
    def to_s
      vars = self.instance_variables - ['@socket', '@opts']
      vars.map! {|var| "#{var.sub('@', '')}=#{self.instance_variable_get(var).inspect}" }
      return "<#{self.class}: #{vars.join ' '}>"
    end

    class << self
      def create_request(socket)
        req_str = socket.read_nonblock(1000000)
        #ScanServer.logger.debug req_str

        if req_str && !req_str.empty?
          req_str = Request.strip_post_header(req_str)
          opts = req_str.chomp.split(/\s/)
          type = opts.first.to_i
          case type
          when SCAN then return ScanRequest.new(socket, opts)
          when INVENTORY then return InventoryRequest.new(socket, opts)
          else raise RuntimeError, "Unknown request type."
          end
        else
          raise RuntimeError, "Bad request."
        end

        return 
      end

      def strip_post_header(str)
        str.sub(/^POST.+\r\n\r\n/m, '').sub(/\r\n/, '')
      end
    end
  end
end
