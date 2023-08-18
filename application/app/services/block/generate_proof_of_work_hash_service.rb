# frozen_string_literal: true

require './app/services/application_service'
require './app/services/digest_service'
require './app/errors/service_error'

class Block
  # Generate hash based on proof of work and previous proof of work
  class GenerateProofOfWorkHashService < ApplicationService
    def initialize(proof_of_work, previous_proof_of_work)
      super()
      @proof_of_work = proof_of_work
      @previous_proof_of_work = previous_proof_of_work
    end

    def call!
      validate_proof_of_works

      proof_of_work_ = @proof_of_work**2 - @previous_proof_of_work**2

      DigestService.sha256_hexdigest(proof_of_work_.to_s)
    end

    private

    def validate_proof_of_works
      %i[proof_of_work previous_proof_of_work].each do |field|
        raise ServiceError, "Missing #{field}" unless instance_variable_get("@#{field}")

        unless Application.instance.blockchain_proof_of_work_range.cover?(instance_variable_get("@#{field}"))
          raise ServiceError, "#{field} out of the range"
        end
      end
      true
    end
  end
end
