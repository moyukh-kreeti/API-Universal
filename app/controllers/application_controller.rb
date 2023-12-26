class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_method
  before_action :verify_authorization

  def verify_authorization
    header = request.headers['authorization']
    token  = header ? header.split(" ")[1] : nil
    @auth_data  = token ? JwtWebToken.decode(token) : nil
    unless @auth_data
      render :json => {msg: "Session Expired"},status: :unauthorized
    end
  end

  def not_found_method 
    render :json => {msg: "record not found "},status: :not_found
  end
end
