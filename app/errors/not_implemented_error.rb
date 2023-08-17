# frozen_string_literal: true

require_relative './application_error'

# This class is used to raise error when a method is not implemented yet
class NotImplementedError < ApplicationError
  def initialize(message = 'This method is not implemented')
    super(message)
  end
end
