require '../db/init'

module ScanServer
  class InventoryServlet < Servlet
    def execute(request, response)
      user = User[request.user_id]
      response.puts(user.inventory_str)
    end
  end

end
