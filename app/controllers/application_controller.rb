class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :verify_authorization
  rescue_from ActiveRecord::RecordNotFound, with: :handle_invalid_record

  def verify_authorization
    header = request.headers['authorization']
    if(header)
      token  = header.split(" ")[1]
      @auth_data  = JwtWebToken.decode(token)
    end
    unless @auth_data
      render :json => {msg: "Session Expired"},status: :unauthorized
    end
  end

  def handle_invalid_record(e)
    render json: { errors: e }, status: :unprocessable_entity
  end
end
