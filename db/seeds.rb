Admin.create!(name: 'Admin Genérico', email: 'admin@userubis.com.br', password: 'password',
              registration_number: '111.222.333-44', status: :active)
Admin.create!(name: 'Admin de Marca', email: 'admin2@userubis.com.br', password: 'password',
              registration_number: '222.442.333-44', status: :active)

Currency.create!(status: :active, currency_value: 1.5, admin: Admin.first)
Currency.create!(status: :inactive, currency_value: 2, admin: Admin.last)

Category.create!(name: 'Padrão', discount: 0)

ClientWallet.create!(registered_number: '111.111.111-11', email: 'fulano@email.com', category_id: 1)
ClientWallet.create!(registered_number: '222.111.111-11', email: 'cicrano@email.com', category_id: 1)

Transaction.create!(value: 500, registered_number: '111.111.111-11', currency_rate: 1.5, cashback: 30, order: 1)
Transaction.create!(value: 1500, registered_number: '222.111.111-11', currency_rate: 1.5, order: 33)
