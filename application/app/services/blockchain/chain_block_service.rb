# frozen_string_literal: true

require './app/errors/service_error'

class Blockchain
  # Mine a new block on blockchain
  class ChainBlockService < ApplicationService
    def initialize(block)
      super()
      @block = block
    end

    def call!
      raise ServiceError, 'missing mining started at' unless @block.mining_started_at

      @block.hash64 = Block::GenerateBlockHashService.new(@block).call!
      @block.mining_time = Time.now.to_i - @block.mining_started_at
      @block.save!
      Blockchain.instance.update_last_block(@block)

      @block
    end
  end
end
