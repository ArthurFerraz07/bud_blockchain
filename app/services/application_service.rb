# frozen_string_literal: true

# Base class for services
class ApplicationService
  attr_accessor :success, :blockchain

  def initialize
    @success = true
    @blockchain = Blockchain.instance
  end

  class << self
    def call(*args)
      new.call(*args)
    rescue ApplicationError => e
      default_response(false, error: e.message)
    end

    def default_response(success, data = {})
      @success = success
      { success:, data: }
    end
  end

  private

  def default_response(success, data = {})
    self.class.default_response(success, data)
  end
end
