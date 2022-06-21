require 'rails_helper'

describe 'Aplicação lista transações' do
  it 'já executadas' do
    admin = create(:admin, status: :active)
    fake_response = double('farady_response', status: 200, body: JSON.generate(currency_value: 10.0))
    currency_rate = JSON.parse(fake_response.body)

    Transaction.create!(value: 500, registered_number: '111.111.111-11', transaction_type: :debit,
                        currency_rate: currency_rate['currency_value'], status: :accepted)
    Transaction.create!(value: 1500, registered_number: '222.111.111-11', transaction_type: :credit,
                        currency_rate: currency_rate['currency_value'], status: :accepted)
    login_as(admin)
    visit root_path
    click_on 'Transações'

    expect(page).to have_content('Transações Realizadas')
    within('table') do
      within('thead tr') do
        expect(page).to have_css('th', text: 'Número de Registro')
        expect(page).to have_css('th', text: 'Valor')
        expect(page).to have_css('th', text: 'Tipo de Transação')
        expect(page).to have_css('th', text: 'Taxa no Momento')
      end
      within('tbody') do
        expect(page).to have_css('td', text: '111.111.111-11')
        expect(page).to have_css('td', text: 'R$ 500,00')
        expect(page).to have_css('td', text: 'Débito')
        expect(page).to have_css('td', text: '10')
        expect(page).to have_css('td', text: '222.111.111-11')
        expect(page).to have_css('td', text: 'R$ 1.500,00')
        expect(page).to have_css('td', text: 'Crédito')
        expect(page).to have_css('td', text: '10')
      end
    end
  end

  it 'e não há transações cadastradas' do
    admin = create(:admin, status: :active)

    login_as(admin)
    visit root_path
    click_on 'Transações'

    expect(page).to have_content('Transações Realizadas')
    expect(page).to have_content('Não há transações cadastradas')
    expect(page).not_to have_css('table')
  end
end
