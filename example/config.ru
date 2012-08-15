require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-linkedin'

class App < Sinatra::Base
  get '/' do
    redirect '/auth/linkedin'
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end

  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
end

use Rack::Session::Cookie

use OmniAuth::Builder do
  #note that the scope is different from the default
  #we also have to repeat the default fields in order to get
  #the extra 'connections' field in there
  provider :linkedin, ENV['LINKEDIN_CONSUMER_KEY'], ENV['LINKEDIN_CONSUMER_SECRET'], :scope => 'r_fullprofile+r_emailaddress+r_network', :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "connections"]
end

run App.new
