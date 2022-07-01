require 'rails_helper'

describe 'Administrador acessa a tela de cliente' do
  it 'e não há clientes cadastrados' do
    create(:admin, status: :active)

    login_as(Admin.first)
    visit root_path
    click_on 'Carteiras de Clientes'

    expect(page).to have_content 'Ainda não há nenhuma carteira de cliente cadastrada.'
  end

  it 'e muda a categoria do cliente' do
    create(:admin, status: :active)
    create(:category, name: 'Mais que VIP')
    create(:client_wallet)

    login_as(Admin.first)
    visit root_path
    click_on 'Carteiras de Clientes'
    click_on 'Acessar'
    select 'Mais que VIP', from: 'Categoria'
    click_on 'Salvar'

    expect(page).to have_content 'Categoria alterada com sucesso.'
    within('table tbody tr') do
      expect(page).to have_content 'Mais que VIP'
    end
  end

  it 'e vê cliente cadastrado com CNPJ' do
    create(:admin, status: :active)
    create(:client_wallet, registered_number: '41.780.304/0001-04')

    login_as(Admin.first)
    visit root_path
    click_on 'Carteiras de Clientes'

    within('table thead tr') do
      expect(page).to have_content 'CPF ou CNPJ'
    end
    within('table tbody tr') do
      expect(page).to have_content '41.780.304/0001-04'
    end
  end

  it 'e adiciona saldo bônus à carteira do cliente durante promoção' do
    admin = create(:admin, status: :active)
    bonus_conversion = create(:bonus_conversion, percentage: 10, admin:)
    category = create(:category, bonus_conversion:)
    client_wallet = create(:client_wallet, bonus_balance: 0, category:, email: 'teste3@mail.com.br')
    create(:currency)
    create(:credit, bonus_conversion:, client_wallet:, created_at: 1.day.ago)

    login_as(Admin.first)
    visit root_path
    click_on 'Carteiras de Clientes'
    click_on 'Acessar'

    within('dl') do
      expect(page).to have_css 'dt', text: 'CPF ou CNPJ'
      expect(page).to have_css 'dt', text: 'E-mail'
      expect(page).to have_css 'dt', text: 'Saldo'
      expect(page).to have_css 'dt', text: 'Saldo Bônus'
    end
    within('dl') do
      expect(page).to have_css 'dd', text: '111.111.111-11'
      expect(page).to have_css 'dd', text: 'teste3@mail.com.br'
      expect(page).to have_css 'dd', text: 'RU 66,76'
      expect(page).to have_css 'dd', text: 'RU 6,66'
    end
  end

  it 'e tem o saldo bônus expirado após o deadline' do
    admin = create(:admin, status: :active)
    bonus_conversion = create(:bonus_conversion, percentage: 10, initial_date: 12.days.ago,
                                                 final_date: 9.days.ago, admin:)
    category = create(:category, bonus_conversion:)
    client_wallet = create(:client_wallet, category:)
    create(:currency)
    create(:credit, bonus_conversion:, client_wallet:, created_at: 11.days.ago)

    login_as(Admin.first)
    visit root_path
    click_on 'Carteiras de Clientes'
    click_on 'Acessar'

    expect(page).to have_content('Saldo RU 66,76')
    expect(page).to have_content('Saldo Bônus RU 0,00')
    client_wallet.reload
    expect(client_wallet.bonus_balance).to eq(0)
  end

  it 'e tem o saldo bônus expirado após o deadline e não deixa o saldo negativo' do
    admin = create(:admin, status: :active)
    bonus_conversion = create(:bonus_conversion, percentage: 10, initial_date: 12.days.ago,
                                                 final_date: 10.days.ago, admin:)
    category = create(:category, bonus_conversion:)
    client_wallet = create(:client_wallet, category:)
    create(:currency)
    create(:credit, bonus_conversion:, client_wallet:, created_at: 11.days.ago)

    login_as(Admin.first)
    visit root_path
    click_on 'Carteiras de Clientes'
    click_on 'Acessar'

    expect(page).to have_content('Saldo RU 66,76')
    expect(page).to have_content('Saldo Bônus RU 0,00')
    client_wallet.reload
    expect(client_wallet.bonus_balance).to eq(0)
  end
end
