# frozen_string_literal: true

require './app'

# This class handle the application instance
class Application
  @instance = nil
  private_class_method :new

  ENVIRONMENTS = %i[development test production].freeze

  attr_accessor :node, :environment

  class << self
    def instance
      @instance ||= new
      @instance
    end
  end

  def run(environment, node = 3000)
    self.environment = environment&.to_sym
    self.node = node

    validate_environment

    load_database

    set_store_node

    load_constants
  end

  private

  def load_database
    Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'), environment.to_sym)
  end

  def validate_environment
    raise "invalid environment #{environment}" unless ENVIRONMENTS.include?(environment)
  end

  def set_store_node
    Block.store_in_node(node)
  end

  def load_constants
    DefineConstantByHashConst.new(Api::V1::ApplicationController, 'RESPONSE_STATUSES').call
  end
end
