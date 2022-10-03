# frozen_string_literal: true

require 'date'
require 'digest'

require_relative './base_model'

# This class represents a block of a blockchain
class Block < BaseModel
  attr_accessor :hash, :previous_hash, :timestamp, :data, :proof_of_work, :genesis_block

  def initialize(attributes)
    super
    validate_previous_hash
    set_timestamp
    calculate_hash
    @data ||= {}
  end

  def proof_of_work_hash(last_block)
    proof_of_work_ = proof_of_work**2 - last_block.proof_of_work**2
    Digest::SHA256.hexdigest(proof_of_work_.to_s)
  end

  def to_h
    {
      hash:,
      previous_hash:,
      timestamp:,
      data:,
      proof_of_work:,
      genesis_block:
    }
  end

  private

  def calculate_hash
    @hash = genesis_block ? '0' * 64 : Digest::SHA256.hexdigest("#{previous_hash}#{timestamp}#{data}#{proof_of_work}")
  end

  def set_timestamp
    @timestamp = DateTime.now.to_s
  end

  def validate_previous_hash
    raise BaseModelError, 'Missing previous hash' if previous_hash.nil? && !genesis_block
    raise BaseModelError, 'Genesis block must not have a previous hash' if !previous_hash.nil? && genesis_block

    true
  end
end
