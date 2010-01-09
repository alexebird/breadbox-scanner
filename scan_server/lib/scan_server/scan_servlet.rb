require 'scan_server/servlet'
require '../db/init'

module ScanServer
  class ScanServlet < Servlet
    def execute(request, response)
      scanner = Scanner[request.scanner_id]
      food = Food[:rfid => request.rfid]
      scan = Scan.create(:food => food, :scanner => scanner)
      scanner.add_scan(scan)
      food.add_scan(scan)
      user = scanner.user
      user.scan_food(food)
      response.puts(InventoryServlet.inventory_foods_str(user))
    end
  end
end
