require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization, password: 'password') }

  describe "POST /api/v1/sessions" do
    it "authenticates the user and returns a token" do
      post "/api/v1/sessions", params: { email: user.email, password: 'password' }
      expect(response).to have_http_status(:ok)
      expect(parse_json(response)["token"]).to be_present
    end

    it "returns an error for invalid credentials" do
      post "/api/v1/sessions", params: { email: user.email, password: 'wrong_password' }
      expect(response).to have_http_status(:unauthorized)
      expect(parse_json(response)["message"]).to eq("Invalid credentials")
    end
  end

  describe "DELETE /api/v1/sessions" do
    it "logs out the user" do
      token = Jwt.encode({ user_id: user.id, organization_id: user.organization_id })
      delete "/api/v1/sessions", headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(parse_json(response)["message"]).to eq("Logged out successfully")
    end
  end
end
