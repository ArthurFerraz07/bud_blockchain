# frozen_string_literal: true

# This class is the base for all models
class BaseModel
  def initialize(attributes = {})
    attributes.each do |k, v|
      send("#{k}=", v)
    end
  end
end
