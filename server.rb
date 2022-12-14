# frozen_string_literal: true

require 'sinatra'
require_relative './app'

NODE = (ARGV[0] || 3000).freeze
ENVIRONMENT = (ARGV[1] || 'development').freeze

Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'), ENVIRONMENT.to_sym)

Block.store_in_collection(NODE)

print "⚡Web Server Running ⚡\n"

set :port, NODE

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
