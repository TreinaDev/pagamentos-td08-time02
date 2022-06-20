require 'rails_helper'

describe 'Aplicação gerá transação' do
  it 'com sucesso' do
    admin = create(:admin)
    create(:currency, currency_value: 1.5)
    url = 'http://localhost:3000/api/v1/current_rate'
    response = Faraday.get(url)
    currency_rate = JSON.parse(response.body)
    Transaction.create!(value: 500, registered_number: '111.111.111-11', type: :debit, 
                        currency_rate: currency_rate['currency_value'], status: :accepted)

    login_as admin
    visit root_path
    click_on 'Transações'

    expect(page).to have_content 'Transações Realizadas'
    within('table') do
      within('thead tr') do
        expect(page).to have_css('th', text: 'Número de Registro')
        expect(page).to have_css('th', text: 'Valor')
        expect(page).to have_css('th', text: 'Tipo')
        expect(page).to have_css('th', text: 'Taxa no Momento')
      end
      within('tbody tr') do
        expect(page).to have_css('td', text: '111.111.111-11')
        expect(page).to have_css('td', text: 'R$ 500,00')
        expect(page).to have_css('td', text: 'Débito')
        expect(page).to have_css('td', text: '1.5')
      end
    end
  end
end