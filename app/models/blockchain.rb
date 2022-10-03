# frozen_string_literal: true

require_relative './base_model'
require_relative './block'
require_relative './../errors/application_error'

# This class manage the blockchain logic
class Blockchain < BaseModel
  DIFFICULT = 4
  PROOF_OF_WORK_RANGE = 1_000_000_000..9_999_999_999
  PROOF_OF_WORK_HASH_START_WITH = '0' * DIFFICULT

  attr_accessor :chain, :genesis_block, :last_block

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
    self.chain = {}
    generate_genesis_block
  end

  def mine_block(data)
    loop do
      proof_of_work = rand(PROOF_OF_WORK_RANGE)
      block = Block.new(previous_hash: last_block.hash, data:, proof_of_work:)
      next unless block_tuple_valid?(block, last_block)

      chain_block(block)
      break
    end
  end

  def validate_chain
    it_count = 0
    block = last_block
    loop do
      break if block.genesis_block

      previous_block = chain[block.previous_hash]

      unless block_tuple_valid?(block, previous_block)
        raise ApplicationError, "Invalid block tuple. Block: #{block.hash}. Previous block: #{previous_block.hash}"
      end

      block = previous_block
      it_count += 1
    end
    raise ApplicationError, 'Invalid chain' unless it_count == chain.size - 1
  end

  private

  def block_tuple_valid?(block, previous_block)
    proof_of_work_hash = Block.proof_of_work_hash(block.proof_of_work, previous_block.proof_of_work)
    proof_of_work_hash.start_with?(PROOF_OF_WORK_HASH_START_WITH) && block.previous_hash == previous_block.hash
  end

  def chain_block(block)
    self.last_block = block
    chain.merge!(block.hash => block)
  end

  def generate_genesis_block
    self.genesis_block = Block.new(previous_hash: nil, genesis_block: true, proof_of_work: rand(PROOF_OF_WORK_RANGE))
    chain_block(genesis_block)
  end
end
