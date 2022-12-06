FactoryBot.define do
  factory :user do
    sequence(:id) {|n| 10000140+n}
    sequence(:first_name) {|n| "Test#{n}"}
    sequence(:last_name) {|n| "User#{n}"}
    sequence(:email) {|n| "test_user#{n+140}@example.com"}
    sequence(:mailing_address) {|n| "Address #{n} Postal code #{rand(10001...99999)}"}
    phone_number {"+#{rand(100000000001...999999999999)}"}
    password {"pass_#{rand(10000000...99999999)}"}
    # password {"pass_1234"}
    created_at {Time.current}
    updated_at {Time.current}
  end
end
