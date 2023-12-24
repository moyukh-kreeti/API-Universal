class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :verify_authorization

  def verify_authorization
    header = request.headers['authorization']
    token  = header.split(" ")[1]
    @auth_data  = JwtWebToken.decode(token)
    unless @auth_data
      render :json => {msg: "Session Expired"},status: :unauthorized
    end
  end
end
