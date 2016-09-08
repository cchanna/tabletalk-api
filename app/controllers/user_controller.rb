class UserController < ApplicationController
  def login
    provider = nil
    if Rails.env.test?
      provider = params[:provider] || "test"
    else
      provider = params[:provider] || "google"
    end
    Rails::logger.debug params[:provider]
    Rails::logger.debug provider
    @auth = User.login request.headers[:token], provider
    return render 'auth_error', status: :unauthorized unless @auth
    @token = Token.create_from @auth
  end
end
