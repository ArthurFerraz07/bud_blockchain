# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class ValidateChainService < ApplicationService
    attr_accessor :blockchain

    def call
      load_chain
      default_response(blockchain.validate_chain)
    end

    private

    def load_chain
      self.blockchain = Blockchain.instance
    end
  end
end
