require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "my example app" do
  it "should successfully return a greeting" do
    get '/'
    last_response.body.must_include 'Rest2DNS remote API'
  end

  it "should list" do
    get '/zones'
    assert last_response.ok?
  end

  it "should create new zone" do
    # request.env['RAW_POST_DATA']
    data= {
      "zones": [
        "somezone.cz",
        "otherzonewithsamecontent.cz"
      ],
      "content": "$TTL 600\n@ 600 IN SOA ns.kraxnet.cz. admin.kraxnet.cz. 2018073101 3600 600 3600000 86400\n@ 600 IN A 178.217.244.33\n@ 600 IN MX 10 cust4.xnet.cz.\n@ 600 IN NS ns.kraxnet.cz.\n@ 600 IN NS ns.kraxnet.com.\n@ 600 IN TXT \"keybase-site-verification=Xf5rKKvYLE7XLyzXASVT1d_GHKCPeicW9iRoLm-sR5g\" *\n* 600 IN CNAME easy5.xnet.cz.\nblog 600 IN A 72.32.231.8\nbouncer 600 IN A 178.217.247.148\ncal 600 IN CNAME ghs.google.com.\ndocs 600 IN CNAME ghs.google.com.\ngoogleffffffffa0b6f2c6 600 IN CNAME google.com.\nipv6 600 IN AAAA 2a02:1360::56\nlocalhost 600 IN A 127.0.0.1\nmail 600 IN CNAME ghs.google.com.\nrails 600 IN CNAME ghs.google.com.\nserver 600 IN A 178.217.247.170\nwww 600 IN CNAME kubicek.github.io."
    }.to_json
    post '/zones', data, "CONTENT_TYPE" => 'application/json'

    assert last_response.ok?
  end

  it "should delete zone" do
    delete '/zones', {zones: ["somezone.ll"]}.to_json, "CONTENT_TYPE": 'application/json'
    assert last_response.ok?
  end

  it "should check zonefile" do
    data= {
      "zones": [
        "somezone.cz",
        "otherzonewithsamecontent.cz"
      ],
      "content": "$TTL 600\n@ 600 IN SOA ns.kraxnet.cz. admin.kraxnet.cz. 2018073101 3600 600 3600000 86400\n@ 600 IN A 178.217.244.33\n@ 600 IN MX 10 cust4.xnet.cz.\n@ 600 IN NS ns.kraxnet.cz.\n@ 600 IN NS ns.kraxnet.com.\n@ 600 IN TXT \"keybase-site-verification=Xf5rKKvYLE7XLyzXASVT1d_GHKCPeicW9iRoLm-sR5g\" *\n* 600 IN CNAME easy5.xnet.cz.\nblog 600 IN A 72.32.231.8\nbouncer 600 IN A 178.217.247.148\ncal 600 IN CNAME ghs.google.com.\ndocs 600 IN CNAME ghs.google.com.\ngoogleffffffffa0b6f2c6 600 IN CNAME google.com.\nipv6 600 IN AAAA 2a02:1360::56\nlocalhost 600 IN A 127.0.0.1\nmail 600 IN CNAME ghs.google.com.\nrails 600 IN CNAME ghs.google.com.\nserver 600 IN A 178.217.247.170\nwww 600 IN CNAME kubicek.github.io."
    }.to_json
    post '/zones/check', data, "CONTENT_TYPE": 'application/json'
    assert last_response.ok?
  end


end
