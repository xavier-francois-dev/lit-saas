class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      render json: { message: "Successfully signed in" }, status: :ok
    else
      render json: { message: "Try another email address or password." }, status: :unauthorized
    end
  end

  def destroy
    terminate_session
    render json: {}, status: :ok
  end
end
