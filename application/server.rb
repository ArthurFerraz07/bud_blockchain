# frozen_string_literal: true

require 'sinatra'
require 'dotenv'
require './application_runner'

Dotenv.load

node = (ENV['NODE'] || 3000).freeze
environment = (ENV['ENVIRONMENT'] || 'development').freeze

ApplicationRunner.new(environment, node).run

print "⚡ Web Server Running ⚡\n\n"
print "--- Mode  #{environment} ---\n\n"
print "--- Node #{node} ---\n\n"

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
