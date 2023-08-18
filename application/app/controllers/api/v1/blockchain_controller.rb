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
        Blockchain::ValidateChainService.new.call!

        render(data: { valid: true })
      rescue ServiceError => e
        render(data: { error: e.message }, status: 'STATUS_SERVICE_ERROR')
      rescue StandardError => e
        unexpected_error(e)
      end

      def mine_block
        parse_request_body

        mined_block = Blockchain::MineBlockService.new(params['data']).call!

        render(data: { block: mined_block.to_hash })
      rescue ServiceError => e
        render(data: { error: e.message }, status: 'STATUS_SERVICE_ERROR')
      rescue StandardError => e
        unexpected_error(e)
      end
    end
  end
end
