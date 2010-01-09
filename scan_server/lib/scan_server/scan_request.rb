module ScanServer

  # === ScanRequest Format
  # * <tt>type scanner_id rfid location</tt>
  #
  class ScanRequest
    include Request
    attr_reader :rfid, :location

    def initialize(socket, opts)
      super(socket, opts)
      @rfid = opts[2]
      @location = opts[3]
    end

    def type
      Request::SCAN
    end
  end
end
