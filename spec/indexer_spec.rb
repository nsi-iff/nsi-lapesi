require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "NsiLapesi::Indexer" do

  before(:each) do
    NSILapesi::Configuration.configure do |conf|
      conf.host 'localhost'
      conf.port 8080
      conf.path '/'
    end

    @indexer = NSILapesi::Indexer.new
    NSILapesi::FakeServer.start
    sleep(1)
  end

  after(:all) do
    NSILapesi::FakeServer.stop
  end

  it 'can add an image to lapesi' do
    img  = File.open('spec/resources/debian.jpg')
    code = @indexer.add_image(img, '1', 'Foo', 'BarFoo', 'jpg', 'Artigo', ['teste'])
    code.should == 100
  end

  it 'should create xml contract' do
    expected_contract = %[<?xml version="1.0" encoding="iso-8859-1"?>\n<document>\n  <id>1</id>\n  <author>Foo</author>\n  <title>BarFoo</title>\n  <publication-date>10/10/2012</publication-date>\n  <format>jpg</format>\n  <type>Artigo</type>\n  <keywords>teste</keywords>\n</document>\n]
    contract = @indexer.send(:create_xml_contract, id: '1', author: 'Foo',
                             title: 'BarFoo', format: 'jpg', type: 'Artigo',
                             keywords: ['teste'])
    contract.should == expected_contract
  end
end
