# frozen_string_literal: true

require 'sinatra'
require './application_runner'

node = (ARGV[0] || 3000).freeze
environment = (ARGV[1] || 'development').freeze

ApplicationRunner.new(environment, node).run

print "⚡Web Server Running ⚡\n"

set :port, node

get '/' do
  Api::V1::ApplicationController.new(request).index
end

get '/api/v1/blockchain' do
  content_type :json

  Api::V1::BlockchainController.new(request).index
end

get '/api/v1/blockchain/validate_chain' do
  content_type :json

  Api::V1::BlockchainController.new(request).validate_chain
end

post '/api/v1/blockchain/mine_block' do
  content_type :json

  Api::V1::BlockchainController.new(request).mine_block
end
