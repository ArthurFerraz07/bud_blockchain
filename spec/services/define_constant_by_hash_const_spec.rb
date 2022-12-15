# frozen_string_literal: true

require './spec/spec_helper'

class Klass
  CONST = { A: 1, B: 2 }.freeze
end

RSpec.describe DefineConstantByHashConst do
  let(:klass) { Klass }
  let(:const_name) { :CONST }

  let(:subject) { described_class.new(klass, const_name) }

  let(:response) { subject.call }

  describe '#call' do
    context 'when every little thing go alright' do
      it 'expects to return a success response' do
        expect(response.error).to be_nil
        expect(response.success).to eq(true)
      end

      it 'expects to define the constants' do
        subject.call
        expect(Klass::A).to eq(1)
        expect(Klass::B).to eq(2)
      end
    end
  end
end
