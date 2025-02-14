require 'rails_helper'

RSpec.describe "Web::Sessions", type: :request do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization, password: "Password123") }

  describe "web login" do
    it "authenticates the user and creates a session" do
      post "/web/sessions", params: { email: user.email, password: "Password123" }
      expect(response).to have_http_status(:ok)
      expect(parse_json(response)["message"]).to eq("Login successful")
    end

    it "returns an error for invalid credentials" do
      post "/web/sessions", params: { email: user.email, password: 'wrong_password' }
      expect(response).to have_http_status(:unauthorized)
      expect(parse_json(response)["message"]).to eq("Invalid credentials")
    end
  end

  describe "DELETE /web/sessions" do
    it "logs out the user" do
      post "/web/sessions", params: { email: user.email, password: 'Password123' }
      delete "/web/sessions"
      expect(response).to have_http_status(:ok)
      expect(parse_json(response)["message"]).to eq("Logout successful")
    end
  end
end
