# frozen_string_literal: true

require 'dotenv'
require './application_runner'

Dotenv.load

node = (ENV['NODE'] || 3000).freeze
environment = (ENV['ENVIRONMENT'] || 'development').freeze

ApplicationRunner.new(environment, node).run

binding.pry
