module NSILapesi
  class Configuration
    class << self
      def host(host = nil)
        @host = host unless host.nil?
        @host
      end

      def port(port = nil)
        @port = port unless port.nil?
        @port
      end

      def path(path = nil)
        @path = path unless path.nil?
        @path
      end

      def configure
        yield self if block_given?
        settings
      end

      def settings
        {host: @host, port: @port, path: @path}
      end
    end
  end
end