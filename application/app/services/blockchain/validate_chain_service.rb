# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class ValidateChainService < ApplicationService
    attr_accessor :blockchain

    def call!
      Blockchain.instance.validate_chain

      success_response
    end
  end
end
