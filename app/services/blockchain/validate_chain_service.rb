# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class ValidateChainService < ApplicationService
    attr_accessor :blockchain

    def call
      load_blockchain

      blockchain.validate_chain

      success_response
    rescue StandardError => e
      error_response(e)
    end
  end
end
