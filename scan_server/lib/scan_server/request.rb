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
      vars.map! {|var| "#{var}=#{self.instance_variable_get(var).inspect}" }
      return "<#{self.class}: #{vars.join ' '}>"
    end

    public 
    def self.create_request(socket)
      req_str = socket.gets 
      if req_str && !req_str.empty?
        opts = req_str.chomp.split(/\s/)
        type = opts.first.to_i
        case type
          when SCAN then return ScanRequest.new(socket, opts)
          when INVENTORY then return InventoryRequest.new(socket, opts)
          else raise RuntimeError, "Bad request type."
        end
      else
        raise RuntimeError, "Bad request."
      end

      return 
    end
  end
end
