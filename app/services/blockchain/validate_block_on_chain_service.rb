# frozen_string_literal: true

class Blockchain
  # Mine a new block on blockchain
  class ValidateBlockOnChainService < ApplicationService
    attr_accessor :block

    def initialize(block)
      super()
      self.block = block
    end

    def call
      call!
      success_response(block:)
    rescue StandardError => e
      error_response(e)
    end

    def call!
      proof_of_work_hash = Block::GenerateProofOfWorkHashService.new(block.proof_of_work, block.previous_block.proof_of_work).call!
      unless proof_of_work_hash.start_with?(PROOF_OF_WORK_HASH_STARTS_WITH)
        raise ServiceError, "#{'[CRITICAL]' if critical?} On chain previous block invalid"
      end

      if critical? && block.hash64 != Block::GenerateBlockHashService.new(block).call!
        raise ServiceError, "[CRITICAL] On chain block hash64 invalid. hash64: #{block.hash64}"
      end

      true
    end

    private

    def critical?
      block.persisted?
    end
  end
end
