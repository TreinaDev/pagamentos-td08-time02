FactoryBot.define do
  factory :transaction do
    value { 1 }
    registered_number { "MyString" }
    type { 1 }
    status { 1 }
    currency_rate { 1.5 }
  end
end
