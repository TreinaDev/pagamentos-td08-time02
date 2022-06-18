require 'rails_helper'

describe 'Administrador cria uma categoria' do
  it 'enquanto há outra pendente' do
    admin = create(:admin, status: :active)
    create(:currency)
    create(:currency, currency_value: 2)

    login_as(admin)
    post(admin_backoffice_currencies_path, params: { currency: { currency_value: 3, admin: admin } })

    expect(response).to redirect_to(admin_backoffice_currencies_path)
  end
end