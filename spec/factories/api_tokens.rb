FactoryBot.define do
  factory :api_token do
    association :api_user, factory: :api_user
    token { SecureRandom.hex(20) }
    expires_at { 1.year.from_now }
  end
end
