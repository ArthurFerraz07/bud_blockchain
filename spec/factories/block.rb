# frozen_string_literal: true

require 'factory_bot'

FactoryBot.define do
  factory :block do
    initialize_with do
      new(attributes.merge(previous_hash64:, data:, genesis:))
    end

    previous_hash64 { '0' * 64 }
    data { {} }
    genesis { false }

    trait :genesis do
      genesis { true }
      previous_hash64 { nil }
    end
  end
end
