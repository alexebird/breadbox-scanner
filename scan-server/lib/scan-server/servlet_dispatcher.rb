require 'scan-server/servlet'
require 'scan-server/confirm_servlet'
require 'scan-server/inventory_servlet'
require 'scan-server/scan_servlet'

module ScanServer
  class ServletDispatcher
    def initialize
      confirm_servlet = ConfirmServlet.new
      @servlets = {
        Request::SCAN => ScanServlet.new,
        Request::INVENTORY => InventoryServlet.new,
        Request::CONFIRM_YES => confirm_servlet,
        Request::CONFIRM_NO => confirm_servlet }
    end
    
    def dispatch(request)
      @servlets[request.type].do_execute(request)
    end
  end
end
