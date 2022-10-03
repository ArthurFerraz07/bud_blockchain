# frozen_string_literal: true

class Blockchain
  # Show the blockchain
  class ShowService < ApplicationService
    def call
      blockchain = Blockchain.instance
      { chain: blockchain.chain.values.map(&:to_h) }
    end
  end
end
