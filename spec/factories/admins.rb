FactoryBot.define do
  factory :admin do
    registration_number { '111.222.333-44' }
    name { 'Admin de Solza' }
    email { 'admin@userubis.com.br' }
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
