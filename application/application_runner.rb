# frozen_string_literal: true

Bundler.require(:default)

Dir['app/repositories/*.rb'].each { |file| require "./#{file}" }
Dir['app/models/*.rb'].each { |file| require "./#{file}" }
Dir['app/services/*.rb'].each { |file| require "./#{file}" }
Dir['app/services/*/*.rb'].each { |file| require "./#{file}" }
Dir['app/controllers/*/*/*.rb'].each { |file| require "./#{file}" }

require './application'

class ApplicationRunner
  attr_reader :environment, :node, :application

  def initialize(environment, node)
    @environment = environment
    @node = node
    @application = Application.instance
  end

  def run
    application.start(environment, node)
    define_constants
    load_database
    set_store_node
    handle_blockchain_instance
  end

  private

  def define_constants
    DefineConstantByHashConst.new(Api::V1::ApplicationController, 'RESPONSE_STATUSES').call!
  end

  def load_database
    Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'), environment.to_sym)
  end

  def set_store_node
    Block.store_in_node(node)
  end

  def handle_blockchain_instance
    Blockchain.instance
    Blockchain::HandleGenesisBlockService.new.call!
  end
end
