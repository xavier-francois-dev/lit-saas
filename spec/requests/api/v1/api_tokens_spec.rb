require 'rails_helper'

RSpec.describe "Api::V1::ApiTokens", type: :request do
  let!(:organization) { create(:organization) }
  let!(:api_user) { create(:api_user, organization: organization) }
  let!(:existing_user) { create(:api_user, email: 'existing_user@example.com', organization: organization) }
  let!(:api_token) { create(:api_token, api_user: api_user, expires_at: 1.year.from_now) }

  describe "POST /api/v1/api_tokens" do
    context "with valid parameters" do
      it "creates a new API token for the specified user" do
        post "/api/v1/api_tokens", params: { email: 'new_api_user@example.com', organization_id: organization.id }
        expect(response).to have_http_status(:ok)
        expect(parse_json(response)['token']).to be_present

        new_api_user = ApiUser.find_by(email: 'new_api_user@example.com')
        expect(new_api_user).to be_present
        expect(new_api_user.organization).to eq(organization)
      end

      it "does not create a new user if the user already exists" do
        post "/api/v1/api_tokens", params: { email: 'existing_user@example.com', organization_id: organization.id }
        expect(response).to have_http_status(:ok)
        expect(parse_json(response)['token']).to be_present

        # Check that no additional user is created
        expect(ApiUser.where(email: 'existing_user@example.com').count).to eq(1)
      end
    end

    context "with invalid parameters" do
      it "returns an error for missing email" do
        post "/api/v1/api_tokens", params: { email: '', organization_id: organization.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error for missing organization_id" do
        post "/api/v1/api_tokens", params: { email: 'new_api_user@example.com', organization_id: nil }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/api_tokens" do
    context "with valid token" do
      it "revokes the API token" do
        delete "/api/v1/api_tokens", headers: { 'X-API-TOKEN' => api_token.token }
        expect(response).to have_http_status(:ok)
        expect(parse_json(response)['message']).to eq("Token revoked successfully")
      end
    end

    context "with invalid token" do
      it "returns an error for invalid token" do
        delete "/api/v1/api_tokens", headers: { 'X-API-TOKEN' => 'invalid_token' }
        expect(response).to have_http_status(:unauthorized)
        expect(parse_json(response)['error']).to eq("Unauthorized")
      end
    end

    context "with expired token" do
      it "returns an error for expired token" do
        api_token.update(expires_at: 1.day.ago)
        delete "/api/v1/api_tokens", headers: { 'X-API-TOKEN' => api_token.token }
        expect(response).to have_http_status(:unauthorized)
        expect(parse_json(response)['error']).to eq("Invalid token")
      end
    end
  end
end
