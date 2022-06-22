FactoryBot.define do
  factory :currency do
    status { :active }
    currency_value { 1.5 }
    admin_id { Admin.first.id }
  end
end
