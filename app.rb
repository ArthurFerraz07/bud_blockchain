# frozen_string_literal: true

Bundler.require(:default)

Dir['app/models/*.rb'].each { |file| require "./#{file}" }
Dir['app/services/*.rb'].each { |file| require "./#{file}" }
Dir['app/services/*/*.rb'].each { |file| require "./#{file}" }
Dir['app/controllers/*/*/*.rb'].each { |file| require "./#{file}" }

DefineConstantByHashConst.new(Api::V1::ApplicationController, 'RESPONSE_STATUSES').call
