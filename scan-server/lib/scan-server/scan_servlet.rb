require '../db/init'

module ScanServer
  class ScanServlet < Servlet
    def execute(request, response)
      scanner = Scanner[request.scanner_id]
      food = Food[:rfid => request.options.first]
      scan = Scan.create(:food => food, :scanner => scanner)
      scanner.add_scan(scan)
      food.add_scan(scan)
      user = scanner.user
      user.add_food(food)
      response.puts(InventoryServlet.inventory_str(user))
    end
  end

end
