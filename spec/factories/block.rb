# frozen_string_literal: true

FactoryBot.define do
  factory :block do
    hash64 { nil }
    previous_hash64 { nil }
    timestamp {  }
    data {  }
    proof_of_work {  }
    genesis_block {  }
    mining_time {  }
  end
end
