require "xmlrpc/server"

module NSILapesi
  class FakeServer
    def addImage(contract, image)
      100
    end

    def self.start
      @thread = Thread.new do
        server = XMLRPC::Server.new(8080)
        server.add_handler("ImageIndexer", NSILapesi::FakeServer.new)
        server.serve
      end
    end

    def self.stop
      @thread.kill
    end
  end
end
