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
        scan = Scan.filter(:food_id => food.id, :user_id => user.id).reverse_order(:scan_time).limit(1).first
        request.puts food.to_lcd_str + " " + Frid.hours_ago_in_words(scan.scan_time.to_i)
      end
    end
  end

  def Frid.hours_ago_in_words(secs)
    hours = (Time.now.to_i - secs) / 3600.0
    hours.round!
    when...
    "#{hours} hours ago"
  end
end
