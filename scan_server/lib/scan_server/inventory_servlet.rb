require 'scan_server/servlet'
require '../db/init'

module ScanServer
  class InventoryServlet < Servlet
    def execute(request, response)
      scanner = Scanner[request.scanner_id]
      response.puts(InventoryServlet.inventory_foods_str(scanner))
    end

    def self.inventory_foods_str(scanner)
      user = scanner.user
      pattern = "| %-20s| %-15s|\n"
      response = pattern % %w(Item Expires)
      response << '=' * 40
      response << "\n"
      user.foods.each do |food|
        response << (pattern % [food.to_lcd_str, food.time_til_expires_for(scanner)])
      end
      return response.chomp
    end
  end
end
