require 'rails_helper'

describe 'Administrador rejeita taxa de conversão' do
  it 'com sucesso' do 
    first_admin = create(:admin, status: :active)
    second_admin = Admin.create!(name: 'Main Admin', registration_number: '33333333333',
                                 email: 'mainadmin@userubis.com.br', password: 'password', status: :active)

    create(:currency)
    second_currency = Currency.create!(currency_value: 4, admin: first_admin)

    login_as(second_admin)
    visit(root_path)
    click_on 'Taxa de Câmbio'
    click_on 'Rejeitar taxa'
    second_currency.reload

    expect(page).to have_current_path(admin_backoffice_currencies_path, ignore_query: true)
    expect(page).to have_content('Taxa rejeitada com sucesso!')
    expect(second_currency.status).to eq('inactive')
  end
end