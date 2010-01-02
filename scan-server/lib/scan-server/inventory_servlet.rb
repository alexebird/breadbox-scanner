require '../db/init'

module ScanServer
  class InventoryServlet < Servlet
    def execute(request)
      user = User[request.user_id]
      request.puts(Servlet.food_summary(user, user.foods))
    end
  end

end
