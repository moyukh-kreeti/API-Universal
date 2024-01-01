class UsersController < ApplicationController

  skip_before_action :verify_authorization, only: ['create']

  def index
      render json: User.all
  end

  def show
    render json: User.find(params[:id])
  end

  def create
    user = User.new(user_params)
    if user.save
      token = JwtWebToken.encode({id: user.id, email: user.email,name: "#{user.first_name} #{user.last_name}"})
      render :json =>{ :token => token, :user_data => {id: user.id,name: "#{user.first_name} #{user.last_name}"}}, status: :ok
    else
      error_messages = user.errors.messages.transform_values { |msg| msg[0] }
      render json: { msg: error_messages }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    user.update!(user_params)
    render json: user
  end

  def destroy
    render json: User.find(params[:id]).destroy
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
