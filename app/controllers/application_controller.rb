class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    User.last
  end

  private

  def success? result
    !result.has_key?(:errors)
  end
end
