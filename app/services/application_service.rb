# frozen_string_literal: true

# Base class for services
class ApplicationService
  attr_accessor :success

  def initialize
    self.success = false
  end

  private

  def default_response(success, data = {})
    self.success = success
    data[:success] = !!success
    data[:error] ||= nil
    struct = Struct.new(*data.keys)
    struct.new(*data.values)
  end

  def success_response(data = {})
    default_response(true, data)
  end

  def error_response(error)
    default_response(false, error: error.message)
  end
end
