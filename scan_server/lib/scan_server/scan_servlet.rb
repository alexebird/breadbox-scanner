require 'scan_server/servlet'
require '../db/init'

module ScanServer
  class ScanServlet < Servlet
    def execute(request, response)
      scanner = Scanner[request.scanner_id]
      food = Food[:rfid => request.rfid]
      if food.nil?
        ScanServer.logger.info "RFID unaccounted for: #{request.rfid}"
      else
        scan = Scan.create(:food => food, :scanner => scanner, :location => request.location)
        scanner.add_scan(scan)
        food.add_scan(scan)
        user = scanner.user
        user.scan_food(food)
      end
      response.puts(InventoryServlet.inventory_foods_str(scanner))
    end
  end
end
