# frozen_string_literal: true

class Blockchain
  # Show the blockchain
  class ShowService < ApplicationService
    def call
      default_response(true, Block.all.map(&:to_h))
    end
  end
end
