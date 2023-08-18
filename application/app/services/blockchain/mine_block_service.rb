# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class MineBlockService < ApplicationService
    PROOF_OF_WORK_RANGE = Application.instance.blockchain_proof_of_work_range

    def initialize(data)
      super()
      @data = data
    end

    def call!
      build_block
      mine_block

      ChainBlockService.new(@block).call!
    end

    private

    def build_block
      raise ServiceError, '[CRITICAL] Missing last block' unless Blockchain.instance.last_block

      @block = Block.new(data: @data)
      @block.previous_hash64 = Blockchain.instance.last_block.hash64
    end

    def mine_block
      @block.mining_started_at = Time.now.to_i
      loop do
        @block.proof_of_work = rand(PROOF_OF_WORK_RANGE)

        p "mining try with proof of work: #{@block.proof_of_work}"

        ValidateBlockOnChainService.new(@block).call!

        break
      rescue ServiceError => _e
        next
      end

      p "mining success with proof of work: #{@block.proof_of_work}"
    end
  end
end
