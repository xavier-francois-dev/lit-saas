class ApiTokenService
  def self.create_token(email:, organization_id:)
    organization = Organization.find(organization_id)
    user = ApiUser.find_or_create_by!(email: email) do |u|
      u.organization = organization
    end

    token = SecureRandom.hex(20)
    ApiToken.create(api_user: user, token: token, expires_at: 1.year.from_now)
  end

  def self.revoke_token(token:)
    api_token = ApiToken.find_by(token: token)
    if api_token.active?
      api_token.destroy
    else
      raise "Invalid token"
    end
  rescue ActiveRecord::RecordNotFound
    raise "Unauthorized"
  end
end
