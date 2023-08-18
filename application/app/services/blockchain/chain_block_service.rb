# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class ChainBlockService < ApplicationService
    attr_accessor :block, :blockchain

    def initialize(block)
      super()
      self.block = block
    end

    def call!
      raise 'missing mining started at' unless block.mining_started_at

      block.hash64 = Block::GenerateBlockHashService.new(block).call!
      block.mining_time = Time.now.to_i - block.mining_started_at
      block.save!
      Blockchain.instance.update_last_block(block)

      success_response({ block: })
    end
  end
end