require 'scan_server/response'
module ScanServer
  class Servlet
    def do_execute(request)
      resp = Response.new(request)
      case request.type
        when Request::INVENTORY then resp.type = Response::INVENTORY
        when Request::SCAN then resp.type = Response::INVENTORY
      end
      execute(request, resp)
      resp.send
    end
  end
end
