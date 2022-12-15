# frozen_string_literal: true

require './app/errors/service_error'

class Block
  # Generate hash based om proof of work and previous proof of work
  class GenerateProofOfWorkHashService < ApplicationService
    attr_accessor :blockchain_proof_of_work_range, :proof_of_work, :previous_proof_of_work

    def initialize(proof_of_work, previous_proof_of_work)
      super()
      self.proof_of_work = proof_of_work
      self.previous_proof_of_work = previous_proof_of_work
    end

    # ATTENTION: When "call" method returns a value instead of a default_response, the method name should be "call!"
    def call!
      load_blockchain_proof_of_work_range
      validate_proof_of_works

      proof_of_work_ = proof_of_work**2 - previous_proof_of_work**2
      Digest::SHA256.hexdigest(proof_of_work_.to_s)
    end

    private

    def load_blockchain_proof_of_work_range
      self.blockchain_proof_of_work_range = Application.instance.blockchain_proof_of_work_range
    end

    def validate_proof_of_works
      %i[proof_of_work previous_proof_of_work].each do |field|
        raise ServiceError, "Missing #{field}" unless send(field)
        raise ServiceError, "#{field} out of the range" unless blockchain_proof_of_work_range.cover?(send(field))
      end
      true
    end
  end
end
