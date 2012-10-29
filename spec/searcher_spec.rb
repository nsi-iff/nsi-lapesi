require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "NSILapesi::Searcher" do
  before(:each) do
    NSILapesi::Configuration.configure do |conf|
      conf.host 'localhost'
      conf.port 8080
      conf.path '/'
    end

    @searcher = NSILapesi::Searcher.new
    NSILapesi::FakeServer.start
    sleep(1)
  end

  after(:all) do
    NSILapesi::FakeServer.stop
  end

  it 'searchs for a image' do
    img = File.open('spec/resources/debian.jpg')
    results = @searcher.search_image img, 5
    results.should == [{"id" => "1223", "score" => "1.0", "duplicated" => "false" }]
  end

  it 'also searches for a base64 image' do
    img = File.open('spec/resources/debian.jpg')
    img_base64 = Base64.encode64(img.read)
    results = @searcher.search_image img_base64, 5
    results.should == [{"id" => "1223", "score" => "1.0", "duplicated" => "false" }]
  end
end
