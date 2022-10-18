# frozen_string_literal: true

require_relative './memo_model'
require_relative './block'
require_relative './../errors/application_error'

# This class manage the blockchain logic
class Blockchain < MemoModel
  DIFFICULT = 4
  PROOF_OF_WORK_RANGE = 1_000_000_000..9_999_999_999
  PROOF_OF_WORK_HASH_START_WITH = '0' * DIFFICULT

  attr_accessor :genesis_block, :last_block

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
    it_count = 0
    block = last_block
    loop do
      break if block.genesis_block

      previous_block = Block.where(hash64: block.previous_hash64).first

      unless block_tuple_valid?(block, previous_block)
        raise ApplicationError, "Invalid block tuple. Block: #{block.hash64}. Previous block: #{previous_block.hash64}"
      end

      block = previous_block
      it_count += 1
    end
    raise ApplicationError, 'Invalid chain' unless it_count == Block.count - 1
  end

  private

  def block_tuple_valid?(block, previous_block)
    proof_of_work_hash = Block.proof_of_work_hash(block.proof_of_work, previous_block.proof_of_work)
    proof_of_work_hash.start_with?(PROOF_OF_WORK_HASH_START_WITH) && block.previous_hash64 == previous_block.hash64
  end

  def chain_block(block, mining_started_at = nil)
    self.last_block = block
    block.mining_time = Time.now.to_i - mining_started_at if mining_started_at
    block.save!
  end

  def handle_genesis_block
    self.genesis_block = Block.where(genesis_block: true).first
    return unless genesis_block.nil?

    self.genesis_block = Block.new(previous_hash64: nil, genesis_block: true, proof_of_work: rand(PROOF_OF_WORK_RANGE))
    chain_block(genesis_block)
  end

  def handle_last_block
    return if last_block

    self.last_block = Block.desc(:timestamp).first
  end
end
