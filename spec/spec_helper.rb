# frozen_string_literal: true

require './app'

Dir['spec/factories/*.rb'].each { |file| require "./#{file}" }

Bundler.require(:test)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

Application.instance.run(:test)
