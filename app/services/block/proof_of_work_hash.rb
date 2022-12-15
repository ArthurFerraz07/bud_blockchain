# frozen_string_literal: true

class Block
  # Generate hash based om proof of work and previous proof of work
  class ProofOfWorkHash < ApplicationService
    attr_accessor :proof_of_work, :previous_proof_of_work

    def initialize(proof_of_work, previous_proof_of_work)
      super()
      self.proof_of_work = proof_of_work
      self.previous_proof_of_work = previous_proof_of_work
    end

    def call
      proof_of_work_ = proof_of_work**2 - previous_proof_of_work**2
      Digest::SHA256.hexdigest(proof_of_work_.to_s)
    end
  end
end
