# frozen_string_literal: true

Bundler.require(:default)

Dir['app/models/*.rb'].each { |file| require "./#{file}" }
Dir['app/services/*.rb'].each { |file| require "./#{file}" }
Dir['app/services/*/*.rb'].each { |file| require "./#{file}" }
Dir['app/api/*.rb'].each { |file| require "./#{file}" }

Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))
