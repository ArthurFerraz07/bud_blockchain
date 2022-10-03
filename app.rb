# frozen_string_literal: true

require 'bundler'

Bundler.require(:default)

Dir['app/models/*.rb'].each { |file| require "./#{file}" }
Dir['app/services/*.rb'].each { |file| require "./#{file}" }
Dir['app/services/*/*.rb'].each { |file| require "./#{file}" }
Dir['app/api/*.rb'].each { |file| require "./#{file}" }

print "⚡Web Server Running ⚡\n"
set :port, 3000

get '/' do
  'Put this in your **** & ***** it!'
end

get '/api/v1/blockchain' do
  content_type :json

  Blockchain::ShowService.call.to_json
end
