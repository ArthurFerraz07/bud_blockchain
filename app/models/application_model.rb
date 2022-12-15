# frozen_string_literal: true

# This class is the base for all models of application. It provides some common methos for all models.
class ApplicationModel
  def valid?
    validate
    true
  end

  def validate
    raise NotImplementedError
  end
end
