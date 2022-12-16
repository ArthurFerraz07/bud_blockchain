# frozen_string_literal: true

require './app'

node = (ARGV[0] || 3000).freeze
environment = (ARGV[1] || 'development').freeze

Application.instance.run(environment, node)

binding.pry
