# frozen_string_literal: true

class BlocksRepository < ApplicationRepository
  def get_by_hash64(hash64)
    @scope.where(hash64:).first
  end

  def all_with_genesis_flag
    @scope.where(genesis: true)
  end
end
