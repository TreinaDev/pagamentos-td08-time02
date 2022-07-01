require 'rails_helper'

describe 'Aplicação lista transações' do
  it 'já executadas' do
    admin = create(:admin, status: :active)
    create(:currency)
    create(:client_wallet, registered_number: '111.111.111-11')
    create(:client_wallet, registered_number: '222.111.111-11', category: Category.first)

    Transaction.create!(value: 500, registered_number: '111.111.111-11',
                        currency_rate: 1.5, cashback: 30, order: 1)
    Transaction.create!(value: 1500, registered_number: '222.111.111-11',
                        currency_rate: 1.5, order: 2)
    login_as(admin)
    visit root_path
    click_on 'Transações'

    expect(page).to have_content('Transações Realizadas')
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
        expect(page).to have_css('td', text: 'RU 5,00')
        expect(page).to have_css('td', text: 'R$ 1,50')
        expect(page).to have_css('td', text: 'RU 0,30')
        expect(page).to have_css('td', text: 'Pendente')
        expect(page).to have_css('td', text: '222.111.111-11')
        expect(page).to have_css('td', text: 'RU 15,00')
        expect(page).to have_css('td', text: 'R$ 1,50')
        expect(page).to have_css('td', text: 'RU 0,00')
        expect(page).to have_css('td', text: 'Pendente')
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
