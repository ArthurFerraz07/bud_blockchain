# frozen_string_literal: true

require_relative './../errors/application_error'

# This class represents a block of a blockchain
class Block
  include Mongoid::Document

  field :hash64, type: String
  field :previous_hash64, type: String
  field :timestamp, type: Integer
  field :data, type: Hash
  field :proof_of_work, type: Integer
  field :genesis_block, type: Boolean, default: false
  field :mining_time, type: Integer

  class << self
    def proof_of_work_hash(proof_of_work, previous_proof_of_work)
      proof_of_work_ = proof_of_work**2 - previous_proof_of_work**2
      Digest::SHA256.hexdigest(proof_of_work_.to_s)
    end
  end

  def initialize(attributes)
    super
    validate_previous_hash
    set_timestamp
    calculate_hash
    self.data ||= {}
  end

  def previous_block
    Block.find(previous_hash64:)
  end

  def to_h
    {
      hash64:,
      previous_hash64:,
      timestamp:,
      data:,
      proof_of_work:,
      mining_time:
    }
  end

  private

  def calculate_hash
    self.hash64 = genesis_block ? '0' * 64 : Digest::SHA256.hexdigest("#{previous_hash64}#{timestamp}#{data}#{proof_of_work}")
  end

  def set_timestamp
    self.timestamp = Time.now.to_i
  end

  def validate_previous_hash
    raise ApplicationError, 'Missing previous hash64' if previous_hash64.nil? && !genesis_block
    raise ApplicationError, 'Genesis block must not have a previous hash64' if !previous_hash64.nil? && genesis_block

    true
  end
end
