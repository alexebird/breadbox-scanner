require '../db/init'

module ScanServer
  class InventoryServlet < Servlet
    def execute(request, response)
      user = Scanner[request.scanner_id].user
      response.puts(user.inventory_str)
    end

    def self.inventory_foods_str(user)
      pattern = "| %-20s| %-15s|\n"
      response = pattern % %w(Item Scanned)
      response << '=' * 40
      response << "\n"
      user.inventory.each do |food|
        response << (pattern % [food.to_lcd_str, ScanServer.time_ago_in_words(food[:scan].to_i)])
      end
      return response.chomp
    end
  end
end
