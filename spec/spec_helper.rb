# frozen_string_literal: true

require_relative './../app'

Dir['spec/factories/*.rb'].each { |file| require "./#{file}" }

Bundler.require(:test)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

Mongoid.load!(File.join(File.dirname(__FILE__), '../', 'config', 'mongoid.yml'), :test)
