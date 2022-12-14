# frozen_string_literal: true

require_relative './application_controller'

module Api
  module V1
    # This class is the entry point for the blockchain API
    class BlockchainController < ApplicationController
      def index
        render(data: { blocks: Block.all.map(&:to_h) })
      end

      def validate_chain
        render(data: { valid: Blockchain::ValidateChainService.call.success })
      end

      def mine_block
        parse_request_body

        service_response = Blockchain::MineBlockService.call(params['data'])

        render(data: { block: service_response.block.to_h })
      end
    end
  end
end
