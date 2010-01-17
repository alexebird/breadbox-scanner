module Ramaze
  module Helper
    module FoodHelper
      def food_form(action, food=nil)
        form(:action => action, :method => :post) do |f|
          f.text "Name", :name, (food ? food.name : nil)
          f.text "RFID", :rfid, (food ? food.rfid : nil)
          f.text "Room", :room, (food ? food.room: nil)
          f.text "Fridge", :fridge, (food ? food.fridge: nil)
          f.text "Freezer", :freezer, (food ? food.freezer: nil)
          f.submit
        end
      end

      def food_from_request(request)
        puts request.params.inspect
        Food.new(:name => request[:name],
                 :rfid => request[:rfid],
                 :room => request[:room],
                 :fridge => request[:fridge],
                 :freezer => request[:freezer])
      end
    end
  end
end
