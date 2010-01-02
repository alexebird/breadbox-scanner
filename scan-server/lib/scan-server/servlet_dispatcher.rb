require 'scan-server/servlet'
require 'scan-server/inventory_servlet'
require 'scan-server/scan_servlet'

module ScanServer
  class ServletDispatcher
    def initialize
      @servlets = {SCAN => ScanServlet.new, INVENTORY => InventoryServlet.new}
    end
    
    def dispatch(request)
      @servlets[request.type].execute(request)
    end
  end
end
