class UserController < ApplicationController
  skip_before_action :require_login, only: [:login]

  def login
    provider = nil
    if Rails.env.test?
      provider = params["provider"] || "test"
    else
      provider = params["provider"] || "google"
    end
    @auth = User.login request.headers["token"], provider
    return render 'auth_error', status: :unauthorized unless @auth
    @token = Token.create_from @auth
  end

  def logout
    @user.logout
  end
end
