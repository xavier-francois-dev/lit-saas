module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user, only: :create

      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = Jwt.encode({ user_id: user.id, organization_id: user.organization_id })
          render json: { token: token }, status: :ok
        else
          render json: { message: "Invalid credentials" }, status: :unauthorized
        end
      end

      def destroy
        # TODO: Implement token invalidation
        render json: { message: "Logged out successfully" }, status: :ok
      end
    end
  end
end
