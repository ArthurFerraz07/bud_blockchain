# frozen_string_literal: true

require './application'
require './application_runner'

Dir['spec/factories/*.rb'].each { |file| require "./#{file}" }

Bundler.require(:test)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

ApplicationRunner.new(:test, 1).run

require 'simplecov'
SimpleCov.start

def randon_proof_of_work
  rand(Application.instance.blockchain_proof_of_work_range)
end
