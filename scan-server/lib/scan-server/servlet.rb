module ScanServer
  class Servlet
    def do_execute(request)
      resp = Response.new(request)
      case request.type
        when ScanServer::INVENTORY then resp.type = Response::INVENTORY
        when ScanServer::SCAN then resp.type = Response::INVENTORY
      end
      execute(request, resp)
    end
  end
end
