require '../db/init'

module ScanServer
  class InventoryServlet < Servlet
    def execute(request, response)
      user = User[:scanner_id => request.scanner_id]
      response.puts(user.inventory_str)
    end
  end
end
