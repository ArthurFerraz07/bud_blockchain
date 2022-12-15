# frozen_string_literal: true

require './spec/spec_helper'

def generate_hash(proof_of_work, previous_proof_of_work)
  proof_of_work_ = proof_of_work**2 - previous_proof_of_work**2
  Digest::SHA256.hexdigest(proof_of_work_.to_s)
end

RSpec.describe Block::ProofOfWorkHashService do
  let(:service) { described_class.new(proof_of_work, previous_proof_of_work) }

  describe '#call' do
    context 'when every little thing go alright' do
      subject { service.call! }

      let(:proof_of_work) { randon_proof_of_work }
      let(:previous_proof_of_work) { randon_proof_of_work }

      it 'is expected to returns the correct SHA256 hash' do
        correct_hash = generate_hash(proof_of_work, previous_proof_of_work)
        expect(subject).to be_a(String)
        expect(subject.size).to eq(64)
        expect(subject).to match(Application.instance.hash64_pattern)
        expect(subject).to eq(correct_hash)
      end
    end

    context 'when proof_of_work is missing' do
      let(:proof_of_work) { nil }
      let(:previous_proof_of_work) { randon_proof_of_work }

      it 'is expected to raise "Missing proof_of_work"' do
        expect { service.call! }.to raise_error(ServiceError, 'Missing proof_of_work')
      end
    end

    context 'when proof_of_work out of range' do
      let(:proof_of_work) { 1 }
      let(:previous_proof_of_work) { randon_proof_of_work }

      it 'is expected to raise "proof_of_work out of the range"' do
        expect { service.call! }.to raise_error(ServiceError, 'proof_of_work out of the range')
      end
    end

    context 'when previous_proof_of_work is missing' do
      let(:proof_of_work) { randon_proof_of_work }
      let(:previous_proof_of_work) { nil }

      it 'is expected to raise "Missing previous_proof_of_work"' do
        expect { service.call! }.to raise_error(ServiceError, 'Missing previous_proof_of_work')
      end
    end

    context 'when previous_proof_of_work out of range' do
      let(:proof_of_work) { randon_proof_of_work }
      let(:previous_proof_of_work) { 1 }

      it 'is expected to raise "previous_proof_of_work out of the range"' do
        expect { service.call! }.to raise_error(ServiceError, 'previous_proof_of_work out of the range')
      end
    end
  end
end
