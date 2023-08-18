# frozen_string_literal: true

require './application_runner'

node = (ARGV[0] || 3000).freeze
environment = (ARGV[1] || 'development').freeze

ApplicationRunner.new(environment, node).run

binding.pry
