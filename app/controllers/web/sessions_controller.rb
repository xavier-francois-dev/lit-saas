module Web
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user, only: :create
    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        render json: { message: "Login successful" }, status: :ok
      else
        render json: { message: "Invalid credentials" }, status: :unauthorized
      end
    end

    def destroy
      session.delete(:user_id)
      render json: { message: "Logout successful" }, status: :ok
    end
  end
end
