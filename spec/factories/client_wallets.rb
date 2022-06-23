FactoryBot.define do
  factory :client_wallet do
    registered_number { '111.111.111-11' }
    sequence (:email) { |n| "teste#{n}@mail.com.br" }
    balance { 10 }
    bonus_balance { 0 }
    category { create(:category) }
  end
end
