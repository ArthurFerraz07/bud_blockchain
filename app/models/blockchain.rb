# frozen_string_literal: true

require_relative './base_model'
require_relative './block'

# This class manage the blockchain logic
class Blockchain < BaseModel
  DIFFICULT = 4
  PROOF_OF_WORK_RANGE = 1_000_000_000..9_999_999_999

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
      next unless block_mined?(block)

      chain_block(block)
      break
    end
  end

  private

  def generate_genesis_block
    self.genesis_block = Block.new(previous_hash: nil, genesis_block: true)
    chain_block(genesis_block)
  end

  def block_mined?(block)
    start_with = '0' * DIFFICULT
    block.proof_of_work_hash(last_block).start_with?(start_with) && block.previous_hash == last_block.hash
  end

  def chain_block(block)
    self.last_block = block
    self.chain.merge!(block.hash => block)
  end
end
