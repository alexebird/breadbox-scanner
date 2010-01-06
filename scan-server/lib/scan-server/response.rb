module ScanServer
  class Response
    INVENTORY = 20

    attr_accessor :type

    def initialize(request)
      @conn = request.conn
      @body = ''
    end

    def to_s
      "<Response: type=#@type body=#@body>"
    end

    def puts(data)
      @body << data
    end

    def send
      @conn.puts("#@type#@body")
    end
  end
end
