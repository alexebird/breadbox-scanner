require 'scan_server/servlet'


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
        response << (pattern % [food.to_lcd_str, "%s %s" % food.time_and_location_for(scanner)])
      end
      return response.chomp
    end
  end
end
