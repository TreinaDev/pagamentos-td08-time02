require 'rails_helper'

describe 'Aplicação lista transações' do
  it 'e administrador aceita transação pendente' do
    admin = create(:admin, status: :active)
    create(:currency)
    create(:client_wallet, registered_number: '111.111.111-11')
    create(:client_wallet, registered_number: '222.111.111-11', category: Category.first)

    Transaction.create!(value: 500, registered_number: '111.111.111-11',
                        currency_rate: 1.5, cashback: 30, order: 1)
    login_as(admin)
    visit root_path
    click_on 'Transações'
    click_on 'Aprovar'

    expect(page).to have_content('Transação Aceita')
    within('table') do
      within('thead tr') do
        expect(page).to have_css('th', text: 'Número de Registro')
        expect(page).to have_css('th', text: 'Valor')
        expect(page).to have_css('th', text: 'Taxa no Momento')
        expect(page).to have_css('th', text: 'Cashback')
        expect(page).to have_css('th', text: 'Status')
      end
      within('tbody') do
        expect(page).to have_css('td', text: '111.111.111-11')
        expect(page).to have_css('td', text: 'RU 500,00')
        expect(page).to have_css('td', text: '1.5')
        expect(page).to have_css('td', text: 'RU 30,00')
        expect(page).to have_css('td', text: 'Aceito')
      end
    end
  end

  it 'e administrador recusa transação pendente' do
    admin = create(:admin, status: :active)
    create(:currency)
    create(:client_wallet, registered_number: '111.111.111-11')
    create(:client_wallet, registered_number: '222.111.111-11', category: Category.first)

    Transaction.create!(value: 500, registered_number: '111.111.111-11',
                        currency_rate: 1.5, cashback: 30, order: 1)
    login_as(admin)
    visit root_path
    click_on 'Transações'
    click_on 'Recusar'

    expect(page).to have_content('Transação Recusada')
    within('table') do
      within('thead tr') do
        expect(page).to have_css('th', text: 'Número de Registro')
        expect(page).to have_css('th', text: 'Valor')
        expect(page).to have_css('th', text: 'Taxa no Momento')
        expect(page).to have_css('th', text: 'Cashback')
        expect(page).to have_css('th', text: 'Status')
      end
      within('tbody') do
        expect(page).to have_css('td', text: '111.111.111-11')
        expect(page).to have_css('td', text: 'RU 500,00')
        expect(page).to have_css('td', text: '1.5')
        expect(page).to have_css('td', text: 'RU 30,00')
        expect(page).to have_css('td', text: 'Rejeitado')
      end
    end
  end
end