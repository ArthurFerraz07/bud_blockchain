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
  field :mining_started_at, type: Integer

  class << self
    def store_in_node(node = 3000)
      store_in(collection: "node_#{node}_blocks")
    end

    def last_block
      order(timestamp: :asc).last
    end
  end

  def initialize(attributes = {})
    super
    self.timestamp ||= Time.now.to_i
    # self.data ||= {}
  end

  def previous_block
    @previous_block ||= Block.where(hash64: previous_hash64).first
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

  def genesis_previous_hash_validations
    return unless genesis

    raise ModelValidationError, 'Genesis block must not have a previous hash64' if previous_hash64

    true
  end

  def non_genesis_previous_hash_validations
    return if genesis

    raise ModelValidationError, 'Missing previous hash64' if previous_hash64.nil?
    raise ModelValidationError, 'Previous block not found' if previous_block.nil?

    true
  end

  def run_validations!
    validate_hash64
    validate_previous_hash
  end

  def validate_hash64
    raise ModelValidationError, 'Missing hash64' if hash64.nil?
    raise ModelValidationError, 'Invalid hash64' unless hash64.match?(Application.instance.hash64_pattern)

    true
  end

  def validate_previous_hash
    genesis_previous_hash_validations
    non_genesis_previous_hash_validations

    true
  end
end
