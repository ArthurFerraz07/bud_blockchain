# frozen_string_literal: true

# This class is the base for all reposotories of application.
class ApplicationRepository
  def initialize(scope)
    @scope = scope
  end
end
