# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class MineBlockService < ApplicationService
    attr_accessor :blockchain

    def call(data)
      load_chain
      blockchain.mine_block(data)
      success_response(block: blockchain.last_block)
    end

    private

    def load_chain
      self.blockchain = Blockchain.instance
    end
  end
end
