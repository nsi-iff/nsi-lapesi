require "xmlrpc/server"

module NSILapesi
  class FakeServer
    class FakeIndexer
      def addImage(contract, image)
        100 #success
      end

      def delImage(id)
        100 #success
      end
    end

    class FakeSearcher
      def searchImage(image, limit)
        '<results items="1" code="100"> <item id="1223" score="1.0" duplicated="false" /> </results>'
      end
    end

    def self.start
      @thread = Thread.new do
        server = XMLRPC::Server.new(8080)
        server.add_handler("ImageIndexer", NSILapesi::FakeServer::FakeIndexer.new)
        server.add_handler("ImageSearcher", NSILapesi::FakeServer::FakeSearcher.new)
        server.serve
      end
    end

    def self.stop
      @thread.kill
    end
  end
end
