require '../db/init'

module ScanServer
  class InventoryServlet < Servlet
    def execute(request)
      user = User[request.user_id]
      request.puts(user.inventory_str)
    end
  end

end
