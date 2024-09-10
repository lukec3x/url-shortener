FactoryBot.define do
  factory :url do
    original_url { "MyString" }
    short_url { "MyString" }
    visits { 1 }
    deleted { false }
    deleted_at { "2024-09-09 22:50:11" }
    user
  end
end
