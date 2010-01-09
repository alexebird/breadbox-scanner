module ScanServer

  # === ScanRequest Format
  # * <tt>type scanner_id rfid</tt>
  #
  class ScanRequest
    include Request
    attr_reader :rfid

    def initialize(socket, opts)
      super(socket, opts)
      @rfid = opts[2]
    end

    def type
      Request::SCAN
    end
  end
end
