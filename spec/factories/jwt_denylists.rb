FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2022-11-22 09:40:21" }
  end
end
