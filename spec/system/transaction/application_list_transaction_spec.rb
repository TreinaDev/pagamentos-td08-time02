require 'rails_helper'

describe 'Aplicação lista transações' do
  it 'já executadas' do
    admin = create(:admin, status: :active)
    create(:currency)
    create(:client_wallet, registered_number: '111.111.111-11')
    create(:client_wallet, registered_number: '222.111.111-11', category: Category.first)

    Transaction.create!(value: 500, registered_number: '111.111.111-11',
                        currency_rate: 1.5, cashback: 30)
    Transaction.create!(value: 1500, registered_number: '222.111.111-11',
                        currency_rate: 1.5)
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
      end
      within('tbody') do
        expect(page).to have_css('td', text: '111.111.111-11')
        expect(page).to have_css('td', text: 'R$ 500,00')
        expect(page).to have_css('td', text: '1.5')
        expect(page).to have_css('td', text: 'R$ 30,00')
        expect(page).to have_css('td', text: '222.111.111-11')
        expect(page).to have_css('td', text: 'R$ 1.500,00')
        expect(page).to have_css('td', text: '1.5')
        expect(page).to have_css('td', text: 'R$ 0,00')
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
