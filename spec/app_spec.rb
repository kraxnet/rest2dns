require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "my example app" do
  it "should successfully return a greeting" do
    get '/'
    last_response.body.must_include 'SimpleSyncDNS remote API'
  end

  it "should list" do
    get '/zones'
    assert last_response.ok?
  end

  it "should create new zone" do
    post '/zones'
    assert last_response.ok?
  end

  it "should delete zone" do
    delete '/zones'
    assert last_response.ok?
  end

  it "should check zonefile" do
    post '/zones/check'
    assert last_response.ok?
  end


end
