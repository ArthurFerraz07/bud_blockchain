# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class ValidateChainService < ApplicationService
    attr_accessor :blockchain

    def call!
      validate_genesis_block
      validate_chain

      true
    end

    private

    def validate_genesis_block
      genesis_blocks_count = BlocksRepository.new(Block).all_with_genesis_flag.count
      return if genesis_blocks_count == 1

      raise ServiceError, "[CRITICAL] Should have only one genesis block, but have #{genesis_blocks_count}"
    end

    def validate_chain
      it_count = 0
      block = Blockchain.instance.last_block
      loop do
        break if block.genesis

        previous_block = BlocksRepository.new(Block).get_by_hash64(block.previous_hash64)

        ValidateBlockOnChainService.new(block).call!

        block = previous_block
        it_count += 1
      end

      raise ServiceError, 'Invalid chain' unless it_count == Block.count - 1
    end
  end
end
