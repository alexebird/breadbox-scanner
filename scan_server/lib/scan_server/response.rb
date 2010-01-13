module ScanServer

  # === Response Format
  # * Response tokens are space separated.
  # * The response type is to be the first two bytes of the response, sent as a string.
  # * Bytes 3 through N are the response body.
  #
  class Response
    INVENTORY = 20

    attr_accessor :type

    def initialize(request)
      @socket = request.socket
      @body = ''
    end

    def to_s
      "<Response: type=#@type body=#@body>"
    end

    def puts(data)
      @body << data
    end

    def send
      contents = "#@type#@body"
      ScanServer.logger.debug "\n" + contents
      @socket.print(contents)
    end
  end
end
