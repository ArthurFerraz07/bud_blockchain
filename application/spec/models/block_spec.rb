# frozen_string_literal: true

require './spec/spec_helper'
require './spec/spec_helpers/spec_block_helper'

RSpec.describe Block do
  include SpecBlockHelper

  let!(:genesis) do
    block_ = Block.where(genesis: true).first
    block_ ||= create(:block, :genesis)
    block_
  end

  let(:freeze_time) { Time.utc(2000, 10, 7, 3, 0, 0) }

  let(:freeze_timestamp) { freeze_time.to_i }

  describe '#store_in_node' do
    context 'when node is 3000' do
      let(:node) { 3000 }
      it 'expects to store blocks in "node_3001_blocks" collection' do
        Block.store_in_node(3001)
        expect(Block.collection.name).to eq('node_3001_blocks')
      end
    end
  end

  describe '#last_block' do
    let!(:block) { create(:block) }

    it 'expects to return the last block' do
      expect(Block.last_block).to eq(block)
    end
  end

  describe '#previous_block' do
    context 'with valid previous_hash64' do
      let(:previous_block) { last_block }
      let(:block) do
        create(:block, previous_hash64: previous_block.hash64)
      end

      it 'expects to return previous_block' do
        expect(block.previous_block.id).to eq(previous_block.id)
      end
    end
  end

  describe '#to_hash' do
    context 'with valid attributes' do
      let(:block) { create(:block) }

      it 'expects to return a hash with the block attributes' do
        expect(block.to_hash).to eq(
          hash64: block.hash64,
          previous_hash64: block.previous_hash64,
          timestamp: block.timestamp,
          data: block.data,
          proof_of_work: block.proof_of_work,
          mining_time: block.mining_time
        )
      end
    end
  end

  describe '#genesis_previous_hash_validations' do
    context 'when block is genesis and is valid' do
      let(:block) { create(:block, :genesis) }

      it 'expects to return true' do
        expect(block.send(:genesis_previous_hash_validations)).to be_truthy
      end
    end

    context 'when block is genesis and has previous_hash64' do
      let(:block) { create(:block, :genesis) }

      before do
        block.previous_hash64 = '0' * 64
      end

      it 'expects to raise error' do
        expect { block.send(:genesis_previous_hash_validations) }.to raise_error(ApplicationError, 'Genesis block must not have a previous hash64')
      end
    end

    context 'when block is not genesis' do
      let(:block) { create(:block) }

      it 'expects to return nil' do
        expect(block.send(:genesis_previous_hash_validations)).to be_nil
      end
    end
  end

  describe '#non_genesis_previous_hash_validations' do
    context 'when block is not genesis and is valid' do
      let(:block) { create(:block) }

      it 'expects to return true' do
        expect(block.send(:non_genesis_previous_hash_validations)).to be_truthy
      end
    end

    context 'when block is not genesis and has no previous_hash64' do
      let(:block) { create(:block) }

      before do
        block.previous_hash64 = nil
      end

      it 'expects to raise error' do
        expect { block.send(:non_genesis_previous_hash_validations) }.to raise_error(ApplicationError, 'Missing previous hash64')
      end
    end

    context 'when block is not genesis and has invalid previous_block' do
      let(:block) { create(:block) }

      before do
        block.previous_hash64 = '0'
        block.instance_variable_set('@previous_block', nil)
      end

      it 'expects to raise error' do
        expect { block.send(:non_genesis_previous_hash_validations) }.to raise_error(ApplicationError, 'Previous block not found')
      end
    end
  end

  describe '#initialize' do
    let(:block) { Block.new(attributes) }

    context 'when block is genesis' do
      let(:attributes) do
        {
          genesis: true,
          previous_hash64: nil
        }
      end

      let(:hash64) { '0' * 64 }

      let(:block_to_h) do
        {
          hash64:,
          previous_hash64: nil,
          timestamp: freeze_timestamp,
          data: {},
          proof_of_work: nil,
          mining_time: nil
        }
      end

      around do |example|
        Timecop.freeze(freeze_time) do
          example.run
        end
      end

      it 'expects to build the correct object' do
        expect(block).to be_a(Block)
        expect(block.to_hash).to eq(block_to_h)
      end
    end

    context 'when block is not genesis' do
      let!(:attributes) do
        {
          genesis: false,
          previous_hash64: '0' * 64,
          proof_of_work: (rand * 10**10).to_i,
          mining_time: 10,
          data: { test: 'test' }
        }
      end

      let(:hash64) { calculate_hash(block: block) }

      let(:block_to_h) do
        {
          hash64:,
          previous_hash64: attributes[:previous_hash64],
          timestamp: freeze_timestamp,
          data: attributes[:data],
          proof_of_work: attributes[:proof_of_work],
          mining_time: attributes[:mining_time]
        }
      end

      around do |example|
        Timecop.freeze(freeze_time) do
          example.run
        end
      end

      it 'expects to build the correct object' do
        expect(block).to be_a(Block)
        expect(block.to_hash).to eq(block_to_h)
      end
    end
  end
end
