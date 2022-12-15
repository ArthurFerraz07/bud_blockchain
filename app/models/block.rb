# frozen_string_literal: true

require './app/errors/model_validation_error'
require './app/models/application_model'

# This class represents a block of a blockchain
class Block < ApplicationModel
  include Mongoid::Document

  field :hash64, type: String
  field :previous_hash64, type: String
  field :timestamp, type: Integer
  field :data, type: Hash
  field :proof_of_work, type: Integer
  field :genesis, type: Boolean, default: false
  field :mining_time, type: Integer

  class << self
    def proof_of_work_hash(proof_of_work, previous_proof_of_work)
      proof_of_work_ = proof_of_work**2 - previous_proof_of_work**2
      Digest::SHA256.hexdigest(proof_of_work_.to_s)
    end

    def store_in_node(node = 3000)
      store_in(collection: "node_#{node}_blocks")
    end

    def last_block
      order(timestamp: :asc).last
    end
  end

  def initialize(attributes = {})
    super
    validate_previous_hash
    set_timestamp
    calculate_hash
    self.data ||= {}
  end

  def previous_block
    Block.where(hash64: previous_hash64).first
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
    self.hash64 = if genesis
                    '0' * 64
                  else
                    Digest::SHA256.hexdigest("#{previous_hash64}#{timestamp}#{data}#{proof_of_work}")
                  end
  end

  def genesis_validations
    return unless genesis

    raise ModelValidationError, 'Genesis block must not have a previous hash64' unless previous_hash64.nil?

    true
  end

  def non_genesis_validations
    return if genesis

    raise ModelValidationError, 'Missing previous hash64' if previous_hash64.nil?
    raise ModelValidationError, 'Invalid previous hash64' if previous_block.nil?

    true
  end

  def set_timestamp
    self.timestamp = Time.now.to_i
  end

  def validate
    validate_previous_hash
  end

  def validate_previous_hash
    genesis_validations
    non_genesis_validations

    true
  end
end
