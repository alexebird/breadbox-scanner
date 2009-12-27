require '../db/init'

module Frid
  class RfidServlet < Servlet

    #def initialize
    #end

    def execute(request)
      user = User[request.user_id]
      food = Food[:rfid => request.rfid]
      Frid.logger.info user
      Frid.logger.info food
    end
  end
end
