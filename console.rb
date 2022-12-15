# frozen_string_literal: true

require './app'

Application.instance.run('development')

binding.pry
