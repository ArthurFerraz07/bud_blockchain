# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class ValidateChainService < ApplicationService
    attr_accessor :blockchain

    def call
      load_chain

      blockchain.validate_chain

      success_response
    rescue StandardError => e
      error_response(e)
    end

    private

    def load_chain
      self.blockchain = Blockchain.instance
    end
  end
end
