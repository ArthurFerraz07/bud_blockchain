# frozen_string_literal: true

# Base class for services
class ApplicationService
  attr_accessor :success

  def initialize
    @success = true
  end

  class << self
    def call(*args)
      new.call(*args)
    end
  end

  private

  def default_response(success, data = {})
    @success = success
    struct = Struct.new(:success, *data.keys)
    struct.new(success, *data.values)
  end
end
