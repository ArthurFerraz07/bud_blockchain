# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class ChainBlockService < ApplicationService
    attr_accessor :block, :blockchain

    def initialize(block)
      super()
      self.block = block
    end

    def call
      call!
    rescue StandardError => e
      error_response(e)
    end

    def call!
      raise 'missing mining started at' unless block.mining_started_at

      load_blockchain

      block.hash64 = Block::GenerateBlockHashService.new(block).call!
      block.mining_time = Time.now.to_i - block.mining_started_at
      block.save!
      blockchain.update_last_block(block)
    end
  end
end
