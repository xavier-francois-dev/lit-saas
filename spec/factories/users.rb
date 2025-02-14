FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password_digest { "MyString" }
    association :organization, factory: :organization
  end
end
