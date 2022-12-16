# frozen_string_literal: true

class Blockchain
  # Handle genesis block
  class HandleGenesisBlockService < ApplicationService
    PROOF_OF_WORK_FLOOR = Application.instance.blockchain_proof_of_work_floor
    def call
      success_response(block: call!)
    rescue StandardError => e
      error_response(e)
    end

    def call!
      genesis_block ||= Block.where(genesis: true).first
      return if genesis_block

      genesis_block = Block.new(
        previous_hash64: nil, 
        genesis: true, 
        mining_started_at: Time.now.to_i, 
        proof_of_work: PROOF_OF_WORK_FLOOR
      )
      ChainBlockService.new(genesis_block).call!
    end
  end
end
