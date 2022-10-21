# frozen_string_literal: true

require_relative './../spec_helper'

RSpec.describe Block do
  describe '#store_in_collection' do
    it 'stores blocks in a collection named after the node' do
      Block.store_in_collection(3001)
      expect(Block.collection.name).to eq('node_3001_blocks')
    end
  end
end
