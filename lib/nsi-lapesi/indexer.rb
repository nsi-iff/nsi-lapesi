require 'builder'
require 'xmlrpc/client'

require File.dirname(__FILE__) + '/configuration'
require File.dirname(__FILE__) + '/errors'

module NSILapesi
  class Indexer

    MIMETYPES = ['jpeg', 'jpg']

    def initialize
      params = Configuration.settings
      @server = XMLRPC::Client.new(params[:host], params[:path], params[:port])
    end

    def add_image(image, id, author, title, format, type, keywords_list)

      contract = create_xml_contract id: id, author: author, title: title,
                                     format: format, type: type, keywords: keywords_list

      raise Errors::ImageFormatNotSupported if not MIMETYPES.include? format

      begin
        image_content = image.read
        status_code = @server.call("ImageIndexer.addImage", XMLRPC::Base64.new(contract),
                                   XMLRPC::Base64.new(image_content))
      rescue Exception => e
        puts e.message
        status_code = 111
      end
    end

    def del_image(id)
      begin
        status_code = @server.call("ImageIndexer.delImage", id)
      rescue Exception
        status_code = 111
      end
    end

    private

    def create_xml_contract(params = {})
      params = {id: '', author: '', title: '', format: '',
                type: '', keywords: '', publicationdate: ''}.merge(params)

      params[:publicationdate] = Time.now.strftime("%d/%m/%Y") if params[:publicationdate].empty?

      contract = Builder::XmlMarkup.new(indent: 2)
      contract.instruct! :xml, :encoding => "iso-8859-1"
      contract.document do |doc|
        doc.tag!(:id, params[:id])
        doc.tag!(:author, params[:author])
        doc.tag!(:title, params[:title])
        doc.tag!('publication-date', params[:publicationdate])
        doc.tag!(:format, params[:format])
        doc.tag!(:type, params[:type])
        doc.tag!(:keywords, params[:keywords].join(', '))
      end
    end
  end
end
