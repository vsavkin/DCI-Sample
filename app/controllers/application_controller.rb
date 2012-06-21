class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    User.create!(name: 'user') if User.count == 0
    User.first
  end
end
