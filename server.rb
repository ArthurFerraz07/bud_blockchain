# frozen_string_literal: true

require 'sinatra'
require_relative './app'

$NODE = (ARGV[0] || 3000).freeze

Block.store_in_collection($NODE)

print "⚡Web Server Running ⚡\n"

set :port, $NODE

get '/' do
  'Put this in your **** & ***** it!'
end

get '/api/v1/blockchain' do
  content_type :json

  Blockchain::ShowService.call.to_json
end

get '/api/v1/blockchain/validate_chain' do
  content_type :json

  Blockchain::ValidateChainService.call.to_json
end

post '/api/v1/blockchain/mine_block' do
  content_type :json

  body = request.body.read
  params = JSON.parse(body.gsub("\r", ""))

  Blockchain::MineBlockService.call(params["data"]).to_json
end
