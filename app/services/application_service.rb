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
    rescue ApplicationError => e
      default_response(false, error: e.message)
    end

    def default_response(success, data = {})
      data[:success] = !!success
      data[:error] ||= nil
      struct = Struct.new(*data.keys)
      struct.new(*data.values)
    end
  end

  private

  def default_response(success, data = {})
    @success = success
    self.class.default_response(success, data)
  end
end
