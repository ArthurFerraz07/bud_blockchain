# frozen_string_literal: true

class BlocksRepository < ApplicationRepository
  def get_by_hash64(hash64)
    @scope.where(hash64: hash64).first
  end
end
