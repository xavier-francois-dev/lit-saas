module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  def authenticate_user
    case request_type
    when :jwt
      authenticate_with_jwt
    when :api
      authenticate_with_api_token
    else
      authenticate_with_session
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  def request_type
    if api_request?
      return :jwt if jwt_token_present?
      return :api if api_token_present?
    end
    :session
  end

  def api_request?
    request.path.start_with?("/api")
  end

  def jwt_token_present?
    request.headers["Authorization"].to_s.split(" ").last.present?
  end

  def api_token_present?
    request.headers["X-API-TOKEN"].to_s.present?
  end

  def authenticate_with_session
    unless current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def authenticate_with_jwt
    token = request.headers["Authorization"]&.split(" ")&.last
    decoded = Jwt.decode(token)

    if decoded
      @current_user = User.find(decoded[:user_id])
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def authenticate_with_api_token
    token = request.headers["X-API-TOKEN"]
    api_token = ApiToken.find_by(token: token)

    if api_token&.valid?
      @current_user = api_token.api_user
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
