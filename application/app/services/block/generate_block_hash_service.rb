# frozen_string_literal: true

require './application'
require './app/errors/service_error'
require './app/services/digest_service'

class Block
  # Generate hash based on block previous_hash64, timestamp, data and proof_of_work
  class GenerateBlockHashService < ApplicationService
    GENESIS_HASH64 = Application.instance.blockchain_genesis_hash64
    HASH_FIELDS = %i[previous_hash64 timestamp data proof_of_work].freeze

    def initialize(block)
      super()
      @block = block
    end

    def call!
      return GENESIS_HASH64 if @block.genesis

      payload = HASH_FIELDS.map do |field|
        value = @block.send(field)
        raise ServiceError, "Missing #{field} value" unless value

        value
      end.join

      DigestService.sha256_hexdigest(payload)
    end
  end
end
