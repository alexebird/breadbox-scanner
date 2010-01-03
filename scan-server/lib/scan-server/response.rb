module ScanServer
  class Response
    INVENTORY = 100
    CONFIRM_SCAN = 200

    attr_reader :type

    def initialize(request, type, msg='')
      @conn = request.conn
    end

    def to_s
      "<Response: type=#@type msg=#@msg>"
    end

    def puts
      @conn.puts("#@type #@msg".strip)
    end
  end
end
