require 'json'

require_relative '../lib/syncdns.rb'

before do
  content_type 'application/json'
end

helpers do
  def json_params
    begin
      JSON.parse(request.body.read)
    rescue => err
      $log.error(err)
      halt 400, { message:'Invalid JSON' }.to_json
    end
  end
end

get '/' do
  "SimpleSyncDNS remote API\n"
end

# setup zone
post '/zones' do
  data = json_params
  result = SyncDNS.setup_zone(data["zones"], data["content"])
  halt (result.last.success? ? 200 : 503), result.first.to_json
end

# delete zone
delete '/zones' do
  data = json_params
  result = SyncDNS.destroy_zone(data["zones"])
  halt (result.last.success? ? 200 : 503), result.first.to_json
end

# check zone
post '/zones/check' do
  "Check zone\n"
end