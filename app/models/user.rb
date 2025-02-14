class User < ApplicationRecord
  belongs_to :organization
  has_many :api_tokens, dependent: :destroy
  has_secure_password
end
