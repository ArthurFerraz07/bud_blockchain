# frozen_string_literal: true

require_relative './../app'

Bundler.require(:test)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
