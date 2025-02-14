class ApiToken < ApplicationRecord
  belongs_to :api_user

  validates :token, presence: true, uniqueness: true

  def active?
    !expired?
  end

  def expired?
    expires_at < Time.current
  end
end
