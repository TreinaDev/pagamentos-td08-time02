Admin.create(name: 'Admin Genérico', email: 'admin@userubis.com.br', password: 'password',
             registration_number: '111.222.333-44', status: :active)
Admin.create(name: 'Admin de Marca', email: 'admin2@userubis.com.br', password: 'password',
             registration_number: '222.442.333-44', status: :active)

Currency.create(status: :active, currency_value: 1.5, admin: Admin.first)
Currency.create(status: :inactive, currency_value: 2, admin: Admin.last)
