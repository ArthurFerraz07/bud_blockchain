# frozen_string_literal: true

require './application'
require './app/errors/application_error'

require_relative './memo_model'
require_relative './block'


# This class manage the blockchain logic
class Blockchain < MemoModel
  DIFFICULT = Application.instance.blockchain_difficult
  PROOF_OF_WORK_RANGE = Application.instance.blockchain_proof_of_work_range
  PROOF_OF_WORK_HASH_STARTS_WITH = Application.instance.blockchain_proof_of_work_hash_starts_with

  attr_accessor :genesis, :last_block

  # Singleton pattern
  @instance = nil
  private_class_method :new

  class << self
    def instance
      @instance ||= new
      @instance
    end
  end

  def initialize
    super
    handle_genesis_block
    handle_last_block
  end

  def mine_block(data)
    mining_started_at = Time.now.to_i
    loop do
      proof_of_work = rand(PROOF_OF_WORK_RANGE)
      block = Block.new(previous_hash64: last_block.hash64, data:, proof_of_work:)
      next unless block_tuple_valid?(block, last_block)

      chain_block(block, mining_started_at)
      break
    end
  end

  def validate_chain
    genesis_blocks_count = Block.where(genesis: true).count
    unless genesis_blocks_count == 1
      raise ApplicationError, "[CRITICAL] Should have only one genesis block, but have #{genesis_blocks_count}"
    end

    it_count = 0
    block = last_block
    loop do
      break if block.genesis

      previous_block = Block.where(hash64: block.previous_hash64).first

      unless block_tuple_valid?(block, previous_block)
        raise ApplicationError, "Invalid block tuple. Block: #{block.hash64}. Previous block: #{previous_block.hash64}"
      end

      block = previous_block
      it_count += 1
    end
    raise ApplicationError, 'Invalid chain' unless it_count == Block.count - 1

    true
  end

  private

  def block_tuple_valid?(block, previous_block)
    proof_of_work_hash = Block::ProofOfWorkHashService.new(block.proof_of_work, previous_block.proof_of_work).call!
    proof_of_work_hash.start_with?(PROOF_OF_WORK_HASH_STARTS_WITH) && block.previous_hash64 == previous_block.hash64
  end

  def chain_block(block, mining_started_at = nil)
    self.last_block = block
    block.mining_time = Time.now.to_i - mining_started_at if mining_started_at
    block.save!
  end

  def handle_genesis_block
    self.genesis = Block.where(genesis: true).first
    return unless genesis.nil?

    self.genesis = Block.new(previous_hash64: nil, genesis: true, proof_of_work: rand(PROOF_OF_WORK_RANGE))
    chain_block(genesis)
  end

  def handle_last_block
    return if last_block

    self.last_block = Block.desc(:timestamp).first
  end
end
