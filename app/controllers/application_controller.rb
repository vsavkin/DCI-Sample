class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def success? result
    !result.has_key?(:errors)
  end
end
