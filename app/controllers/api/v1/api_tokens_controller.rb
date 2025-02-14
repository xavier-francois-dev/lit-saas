module Api
  module V1
    class ApiTokensController < ApplicationController
      before_action :authenticate_user, only: :destroy

      def create
        if validate_creation_params
          api_token = ApiTokenService.create_token(email: params[:email], organization_id: params[:organization_id])
          render json: { token: api_token.token }, status: :ok
        else
          render json: { message: "Missing parameters user or organization" }, status: :unprocessable_entity unless validate_creation_params
        end
      end

      def destroy
        ApiTokenService.revoke_token(token: request.headers["X-API-TOKEN"])
        render json: { message: "Token revoked successfully" }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unauthorized
      end

      private

      def validate_creation_params
        params[:email].present? && params[:organization_id].present?
      end
    end
  end
end
