module ErrorHelper
  def required(params, param)
    unless params.key?(param)
      @param = param.to_s
      return render 'errors/required_param', status: :bad_request
    end
    return params[param]
  end

  def not_found
    return render 'errors/not_found', status: :not_found
  end
end

class ApplicationController < ActionController::API
  before_action :require_login

private

  def require_login
    @user = User.authorize request.headers[:token]
    return render 'users/auth_error', status: :unauthorized unless @user
  end

end
