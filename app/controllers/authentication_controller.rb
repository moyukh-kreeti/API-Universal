class AuthenticationController < ApplicationController

include AuthenticationHelper

  skip_before_action :verify_authorization, only: ['login']

  def login
    @user = User.find_by(email: auth_params[:email])
    if(@user&.authenticate(auth_params[:password]))
      data = post_login_work
      render :json => data, status: :ok
    else
      render :json =>{ :msg => "Invalid Credentials"}, status: :bad_request
    end
  end

  private
  def auth_params
    params.require(:user).permit(:email,:password)
  end
end