class UserController < ApplicationController
  def login
    @user = User.login(params[:token])
    render 'auth_error', status: 402 unless @user
    @token = nil # TODO generate token
  end
end
