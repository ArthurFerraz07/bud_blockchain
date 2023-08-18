# frozen_string_literal: true

require './app/errors/application_error'

# This class handle the application instance
class Application
  @instance = nil
  private_class_method :new

  ENVIRONMENTS = %i[development test production].freeze

  attr_accessor :node, :environment, :started

  class << self
    def instance
      @instance ||= new
      @instance
    end
  end

  def blockchain_genesis_hash64
    '0' * 64
  end

  def blockchain_proof_of_work_floor
    1_000_000_000
  end

  def blockchain_proof_of_work_ceil
    9_999_999_999
  end

  def blockchain_proof_of_work_range
    blockchain_proof_of_work_floor..blockchain_proof_of_work_ceil
  end

  def blockchain_difficult
    4
  end

  def blockchain_proof_of_work_hash_starts_with
    '0' * blockchain_difficult
  end

  def hash64_pattern
    /^[a-f0-9]{64}$/
  end

  def start(environment, node)
    raise ApplicationError, 'Application already started' if started

    self.environment = environment&.to_sym
    self.node = node&.to_i
    self.started = Time.now

    validate_environment
  end

  def to_hash
    {
      node:,
      environment:,
      started:,
      blockchain_genesis_hash64:,
      blockchain_proof_of_work_floor:,
      blockchain_proof_of_work_ceil:,
      blockchain_proof_of_work_range:,
      blockchain_difficult:,
      blockchain_proof_of_work_hash_starts_with:,
      hash64_pattern:,
    }
  end

  private

  def validate_environment
    raise "invalid environment #{environment}" unless ENVIRONMENTS.include?(environment)
  end
end
