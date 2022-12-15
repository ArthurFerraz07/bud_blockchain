# frozen_string_literal: true



class Blockchain

  # Mine a new block on blockchain

  class MineBlockService < ApplicationService

    attr_accessor :blockchain, :block, :data, :mining_started_at, :mining_time



    PROOF_OF_WORK_RANGE = Application.instance.blockchain_proof_of_work_range



    def initialize(data)

      super()

      self.data = data

    end



    def call

      success_response(block: call!)

    rescue StandardError => e

      error_response(e)

    end



    def call!

      load_blockchain

      build_block

      chain_block



      block

    end



    private



    def build_block

      raise ServiceError, '[CRITICAL] Missing last block' unless blockchain.last_block



      self.block = Block.new(data:)

      block.previous_hash64 = blockchain.last_block.hash64

      block.mining_started_at = Time.now.to_i



      loop do

        block.proof_of_work = rand(PROOF_OF_WORK_RANGE)



        # p "mining try with proof of work: #{block.proof_of_work}"



        next unless ValidateBlockOnChainService.new(block).call.success



        break

      end



      p "mining success with proof of work: #{block.proof_of_work}"

    end



    def chain_block

      ChainBlockService.new(block).call!

    end

  end

end

