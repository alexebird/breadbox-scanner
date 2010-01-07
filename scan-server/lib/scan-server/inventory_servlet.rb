require '../db/init'

module ScanServer
  class InventoryServlet < Servlet
    def execute(request, response)
      user = Scanner[request.scanner_id].user
      response.puts(user.inventory_str)
    end
  end
end
