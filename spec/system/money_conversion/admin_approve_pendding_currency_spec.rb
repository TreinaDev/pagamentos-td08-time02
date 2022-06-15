require 'rails_helper'

describe 'Administrador aprova taxa de câmbio superior à 10%' do
  it 'com sucesso' do
    first_admin = create(:admin, status: :active)
    second_admin = Admin.create!(name: 'Main Admin', registration_number: '33333333333',
                                 email: 'mainadmin@userubis.com.br', password: 'password', status: :active)

    create(:currency)
    second_currency = Currency.create!(currency_value: 4, admin: first_admin)

    login_as(second_admin)
    visit(root_path)
    click_on 'Taxa de Câmbio'
    click_on 'Aprovar taxa'
    second_currency.reload

    expect(page).to have_current_path(admin_backoffice_currencies_path, ignore_query: true)
    expect(page).to have_content('Taxa aprovada com sucesso!')
    expect(second_currency.status).to eq('active')
  end

  it 'com sucesso e altera o status da penúltima taxa para inativo' do
    first_admin = create(:admin, status: :active)
    second_admin = Admin.create!(name: 'Main Admin', registration_number: '33333333333',
                                 email: 'mainadmin@userubis.com.br', password: 'password', status: :active)
    currency = create(:currency)
    Currency.create!(currency_value: 4, admin: first_admin)

    login_as(second_admin)
    visit(root_path)
    click_on 'Taxa de Câmbio'
    click_on 'Aprovar taxa'
    currency.reload

    expect(page).to have_current_path(admin_backoffice_currencies_path, ignore_query: true)
    expect(page).to have_content('Taxa aprovada com sucesso!')
    expect(currency.status).to eq('inactive')
  end
end