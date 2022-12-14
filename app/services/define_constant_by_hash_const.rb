# frozen_string_literal: true

# Base class for services
class DefineConstantByHashConst < ApplicationService
  def initialize(klass, const_name)
    super()
    @klass = klass
    @const_name = const_name
  end

  def call
    get_const_hash
    @hash.each do |key, value|
      next if @klass.const_defined?(key)

      @klass.const_set(key, value)
    end
    default_response(true)
  rescue StandardError => e
    default_response(false, error: e.message)
  end

  private

  def get_const_hash
    @hash = @klass.const_get(@const_name)
    raise "Constant #{@const_name} is not a hash" unless @hash.is_a?(Hash)
  end
end
