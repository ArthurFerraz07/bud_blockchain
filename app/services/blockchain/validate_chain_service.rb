# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class ValidateChainService < ApplicationService
    def call
      default_response(blockchain.validate_chain, message: 'Chain is valid')
    end
  end
end
