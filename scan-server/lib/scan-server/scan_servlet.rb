require '../db/init'

module ScanServer
  class ScanServlet < Servlet
    def execute(request, response)
      user = Scanner[request.scanner_id]
      food = Food[:rfid => request.options.first]
      user.add_inventory_food(food)
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
