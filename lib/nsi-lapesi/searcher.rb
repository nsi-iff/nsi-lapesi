require 'xmlsimple'
require 'base64'

require File.dirname(__FILE__) + '/configuration'
require File.dirname(__FILE__) + '/errors'

module NSILapesi
  class Searcher
    def initialize
      params = Configuration.settings
      @server = XMLRPC::Client.new(params[:host], params[:path], params[:port])
    end

    def search_image(image, limit = 5)
      image_content = (image.class == String)? Base64.decode64(image) : image.read

      results_xml = @server.call("ImageSearcher.searchImage", XMLRPC::Base64.new(image_content), limit)
      results = XmlSimple.xml_in results_xml

      (results['code'] == '100')? results['item'] : []
    end
  end
end
