# frozen_string_literal: true

module BlockHelper
  def last_block
    Block.last_block
  end

  def last_hash64
    last_block&.hash64
  end

  def calculate_hash(genesis: false, previous_hash64: nil, timestamp: nil, data: {}, proof_of_work: nil, block: nil)
    if genesis
      '0' * 64
    else
      block ||= Struct.new(:previous_hash64, :timestamp, :data, :proof_of_work).new(previous_hash64, timestamp, data, proof_of_work)
      Digest::SHA256.hexdigest("#{block.previous_hash64}#{block.timestamp}#{block.data}#{block.proof_of_work}")
    end
  end
end
