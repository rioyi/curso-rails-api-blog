FactoryBot.define do
  factory :post do
    title { "MyString" }
    content { "MyText" }
    published { "" }
    user { nil }
  end
end
