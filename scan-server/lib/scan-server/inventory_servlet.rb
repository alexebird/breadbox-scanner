require 'scan-server/servlet'
require '../db/init'

module ScanServer
  class InventoryServlet < Servlet
    def execute(request, response)
      user = Scanner[request.scanner_id].user
      response.puts(InventoryServlet.inventory_foods_str(user))
    end

    def self.inventory_foods_str(user)
      pattern = "| %-20s| %-15s|\n"
      response = pattern % %w(Item Scanned)
      response << '=' * 40
      response << "\n"
      user.foods.each do |food|
        response << (pattern % [food.to_lcd_str, ''])
      end
      return response.chomp
    end
  end
end
