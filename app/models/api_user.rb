class ApiUser < ApplicationRecord
  belongs_to :organization
  has_many :api_tokens, dependent: :destroy
end
