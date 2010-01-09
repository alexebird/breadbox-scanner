require 'scan_server/inventory_servlet'
require 'scan_server/scan_servlet'

module ScanServer
  class ServletDispatcher
    def initialize
      @servlets = {
        Request::SCAN => ScanServlet.new,
        Request::INVENTORY => InventoryServlet.new
      }
    end
    
    def dispatch(request)
      @servlets[request.type].do_execute(request)
    end
  end
end
