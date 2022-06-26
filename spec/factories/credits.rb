FactoryBot.define do
  factory :credit do
    value { 1 }
    bonus_conversion { nil }
    client_wallet { nil }
    status { 1 }
  end
end
