FactoryBot.define do
  factory :bonus_conversion do
    initial_date { DateTime.now }
    final_date { 2.days.from_now }
    deadline { 10 }
    percentage { 1 }
    admin
  end
end
