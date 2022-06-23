FactoryBot.define do
  factory :transaction do
    value { 100 }
    registered_number { '111.111.111-11' }
    status { :pending }
    currency_rate { 1.5 }
    order { 1 }
  end
end
