# frozen_string_literal: true

require './app/errors/service_error'

class Block
  # Generate hash based on block previous_hash64, timestamp, data and proof_of_work
  class GenerateBlockHashService < ApplicationService
    attr_accessor :block

    GENESIS_HASH64 = Application.instance.blockchain_genesis_hash64
    HASH_FIELDS = %i[previous_hash64 timestamp data proof_of_work].freeze

    def initialize(block)
      super()
      self.block = block
    end

    def call!
      return GENESIS_HASH64 if block.genesis

      payload = HASH_FIELDS.map do |field|
        value = block.send(field)
        raise ServiceError, "Missing #{field} value" unless value

        value
      end.join

      Digest::SHA256.hexdigest(payload)
    end
  end
end
