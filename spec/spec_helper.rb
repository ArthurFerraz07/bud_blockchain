# frozen_string_literal: true

require './app'
require './application'

Dir['spec/factories/*.rb'].each { |file| require "./#{file}" }

Bundler.require(:test)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

Application.instance.run(:test)

def randon_proof_of_work
  rand(Application.instance.blockchain_proof_of_work_range)
end
