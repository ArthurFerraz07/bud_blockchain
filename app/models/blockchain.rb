# frozen_string_literal: true

require './application'
require './app/errors/application_error'

require_relative './memo_model'
require_relative './block'


# This class manage the blockchain logic
class Blockchain < MemoModel
  PROOF_OF_WORK_RANGE = Application.instance.blockchain_proof_of_work_range
  PROOF_OF_WORK_HASH_STARTS_WITH = Application.instance.blockchain_proof_of_work_hash_starts_with

  attr_accessor :genesis_block

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
  end

  def last_block
    @last_block ||= Block.desc(:timestamp).first
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

      ValidateBlockOnChainService.new(block).call!

      block = previous_block
      it_count += 1
    end
    raise ApplicationError, 'Invalid chain' unless it_count == Block.count - 1

    true
  end

  def update_last_block(block)
    @last_block = block
  end

  private

  def handle_genesis_block
    self.genesis_block ||= Block.where(genesis: true).first
    return if genesis_block

    self.genesis_block = Block.new(previous_hash64: nil, genesis: true)
    ChainBlockService.new(block).call!
  end
end
