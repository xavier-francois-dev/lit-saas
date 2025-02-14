FactoryBot.define do
  factory :api_user do
    association :organization, factory: :organization
    email { Faker::Internet.email }
  end
end
