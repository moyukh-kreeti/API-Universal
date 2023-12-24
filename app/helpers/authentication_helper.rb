module AuthenticationHelper
  def post_login_work
    client_data = {id: @user.id, email: @user.email,name: "#{@user.first_name} #{@user.last_name}"}
    token = JwtWebToken.encode({id: @user.id, email: @user.email,name: "#{@user.first_name} #{@user.last_name}"})
    {:token => token, :user_data => client_data}
  end
end
