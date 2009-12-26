module Frid
  class RfidServlet < Servlet

    def initialize
      # TODO talk to database or webapp.
    end

    def execute(request)
      Frid.logger.debug "sending response to frid client"
      request.puts(@arduino.last_resp.inspect)
    end
  end
end
