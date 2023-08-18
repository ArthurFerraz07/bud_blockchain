# frozen_string_literal: true

require './application'
require './app/errors/application_error'

require_relative './memo_model'
require_relative './block'

# This class manage the blockchain logic
class Blockchain < MemoModel
  PROOF_OF_WORK_RANGE = Application.instance.blockchain_proof_of_work_range

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

  def last_block
    @last_block ||= Block.desc(:timestamp).first
  end

  def update_last_block(block)
    @last_block = block
  end
end
