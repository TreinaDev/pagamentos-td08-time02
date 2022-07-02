# Transaction.create!(value: 500, registered_number: '111.111.111-11', currency_rate: 1.5, cashback: 30, order: 1)
# Transaction.create!(value: 10, registered_number: '222.111.111-11', currency_rate: 1.5, order: 2)

# Administradores
Admin.create_or_find_by(name: 'Admin Genérico', email: 'admin@userubis.com.br', password: 'password',
                        registration_number: '111.222.333-44', status: :active)
Admin.create_or_find_by(name: 'Admin de Marca', email: 'admin2@userubis.com.br', password: 'password',
                        registration_number: '222.442.333-44', status: :pending)

# Taxas de Câmbio
Currency.create_or_find_by(status: :active, currency_value: 1.5, admin: Admin.first)
Currency.create_or_find_by(status: :inactive, currency_value: 2, admin: Admin.last)

# Limite de Crédito
CreditLimit.create_or_find_by(max_limit: 500_000)

# Carteiras dos Clientes
ClientWallet.create_or_find_by(registered_number: '61.887.261/0001-60', email: 'marquinhos@hotmail.com', category_id: 1)
ClientWallet.create_or_find_by(balance: 500_000, registered_number: '622.894.020-10', email: 'juliana@hotmail.com',
                               category_id: 1)
ClientWallet.create_or_find_by(balance: 10_000, registered_number: '596.412.200-04', email: 'jadson@hotmail.com',
                               category_id: 1)

# Adiciona crédito a uma carteira superior ao limite
Credit.create_or_find_by(value: 1_000_000, client_wallet_id: 1)
