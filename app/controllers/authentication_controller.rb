class AuthenticationController < ApplicationController

  def login
    @user = User.find_by(email: auth_params[:email])
    if(@user.authenticate(auth_params[:password]))
      token = JwtWebToken.encode({id: @user.id})
      render :json =>{ :token => token, :user_data => {id: @user.id}}, status: :ok
    else
      render :json =>{ :msg => "Invalid Credentials"}, status: :bad_request
    end
  end

  def signup

    @user = User.create(auth_params)
    if(@user)
      token = JwtWebToken.encode({id: @user.id})
      render :json =>{ :token => token, :user_data => {id: @user.id}}, status: :ok
    else
      render :json =>{ :msg => "Some Error Occured"}, status: :bad_request
    end

  end

  private
  def auth_params
    params.require(:user).permit(:first_name,:last_name,:email,:password)
  end
end