# frozen_string_literal: true

# This class is the base for all memo models
class MemoModel
  def initialize(attributes = {})
    attributes.each do |k, v|
      send("#{k}=", v)
    end
  end
end
