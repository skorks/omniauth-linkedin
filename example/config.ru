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
  provider :linkedin, ENV['LINKEDIN_CONSUMER_KEY'], ENV['LINKEDIN_CONSUMER_SECRET']
end

run App.new
