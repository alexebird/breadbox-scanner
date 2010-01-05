require '../db/init'

module ScanServer
  class ScanServlet < Servlet
    def execute(request, response)
      user = User[request.user_id]
      food = Food[:rfid => request.options.first]
      scan = Scan.new(:user => user, :food => food, :scan_time => Time.now)
      user.add_scan(scan)
      food.add_scan(scan)
      scan.save

      foods = user.foods
      if foods.include? food
        user.remove_food(food)
      else
        user.add_food(food)
      end

      response.puts(user.inventory_str)
    end
  end

end
