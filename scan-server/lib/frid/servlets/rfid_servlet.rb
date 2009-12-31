require '../db/init'

module Frid
  class RfidServlet < Servlet
    def execute(request)
      user = User[request.user_id]
      food = Food[:rfid => request.rfid]
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

      
      foods.each do |food|
        request.puts food.to_lcd_str
      end
    end
  end
end
