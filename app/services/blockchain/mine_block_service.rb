# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class MineBlockService < ApplicationService
    def call(data)
      blockchain.mine_block(data)
      default_response(true, blockchain.last_block.to_h)
    end
  end
end
