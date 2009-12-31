require '../db/init'

module Frid
  class RfidServlet < Servlet
    def execute(request)
      user = User[request.user_id]
      food = Food[:rfid => request.rfid]
      if user.foods.include? food
        user.remove_food(food)
      else
        user.add_food(food)
      end
    end
  end
end
