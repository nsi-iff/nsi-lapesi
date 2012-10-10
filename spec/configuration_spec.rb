require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "NSILapesi::Configuration" do
  Configuration = NSILapesi::Configuration

  it 'sets server host' do
    Configuration.host 'localhost'
    Configuration.instance_variable_get(:@host).should == 'localhost'
  end

  it 'sets server port' do
    Configuration.port '8080'
    Configuration.instance_variable_get(:@port).should == '8080'
  end

  it 'sets server path' do
    Configuration.path '/serverpath/'
    Configuration.instance_variable_get(:@path).should == '/serverpath/'
  end

  it 'settings returns hash with configurations' do
    Configuration.host 'localhost'
    Configuration.port '80'
    Configuration.path '/path/'
    Configuration.settings.should == {host: 'localhost', port: '80', path: '/path/'}
  end

  it 'configure method receives a block to define configurations parameters' do
    Configuration.configure do |conf|
      conf.host 'localhost'
      conf.port '80'
      conf.path '/path/'
    end

    Configuration.settings.should == {host: 'localhost', port: '80', path: '/path/'}
  end
end