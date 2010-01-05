require '../db/init'

module ScanServer
  class ConfirmServlet < Servlet
    def execute(request, response)
      user = User[request.user_id]
      food = Food[:rfid => request.options.first]
      scan = Scan[request[:scan_id]]
      if request.is_confirm_yes?
        user.add_scan(scan)
        user.save
        food.add_scan(scan)
        food.save
      elsif request.is_confirm_no?
        scan.delete
      end
      response.puts(user.inventory_str)
    end
  end

end
