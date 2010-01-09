module ScanServer

  # === InventoryRequest Format
  # * <tt>type scanner_id</tt>
  #
  class InventoryRequest
    include Request

    def type
      Request::INVENTORY
    end
  end
end
