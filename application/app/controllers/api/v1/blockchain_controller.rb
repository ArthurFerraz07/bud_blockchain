# frozen_string_literal: true

require_relative './application_controller'

module Api
  module V1
    # This class is the entry point for the blockchain API
    class BlockchainController < ApplicationController
      def index
        render(data: { blocks: Block.all.map(&:to_hash) })
      end

      def validate_chain
        service_response = Blockchain::ValidateChainService.new.call!

        render(data: { valid: service_response.success, error: service_response.error })
      rescue StandardError => e
        render(data: { error: e.message }, status: 'STATUS_GENERIC_ERROR')
      end

      def mine_block
        parse_request_body

        service_response = Blockchain::MineBlockService.new(params['data']).call!

        render(data: { block: service_response.block.to_hash })
      rescue StandardError => e
        render(data: { error: e.message }, status: 'STATUS_GENERIC_ERROR')
      end
    end
  end
end