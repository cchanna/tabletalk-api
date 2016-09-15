class ApplicationController < ActionController::API
  before_action :require_login

private

  def require_login
    @user = User.authorize request.headers[:token]
    return render 'user/auth_error', status: :unauthorized unless @user
    Rails::logger.debug @user.id
  end

end
