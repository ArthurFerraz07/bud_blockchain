# frozen_string_literal: true

require_relative './application_error'

# This class is used to raise generic errors inside the services
class ServiceError < ApplicationError; end
