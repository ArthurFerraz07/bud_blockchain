# frozen_string_literal: true

require_relative './app'

Application.instance.run('development')

binding.pry
