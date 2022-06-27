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
    click_on '111.111.111-11'
    select 'Mais que VIP', from: 'Categoria'
    click_on 'Salvar'

    expect(page).to have_content 'Categoria alterada com sucesso.'
    expect(page).to have_content 'Categoria: Mais que VIP'
  end

  it 'e vê cliente cadastrado com CNPJ' do
    create(:admin, status: :active)
    create(:client_wallet, registered_number: '41.780.304/0001-04')

    login_as(Admin.first)
    visit root_path
    click_on 'Carteiras de Clientes'

    expect(page).to have_content 'CPF ou CNPJ: 41.780.304/0001-04'
    expect(page).to have_link '41.780.304/0001-04'
  end

  it 'e adiciona saldo bônus à carteira do cliente durante promoção' do
    admin = create(:admin, status: :active)
    bonus_conversion = create(:bonus_conversion, percentage: 10, admin: admin)
    category = create(:category, bonus_conversion: bonus_conversion)
    client_wallet = create(:client_wallet, bonus_balance: 0, category: category)
    create(:currency)
    credit = create(:credit, bonus_conversion: bonus_conversion, client_wallet: client_wallet, created_at: 1.day.ago)

    login_as(Admin.first)
    visit root_path
    click_on 'Carteiras de Clientes'
    click_on client_wallet.registered_number

    expect(page).to have_content('Saldo 76')
    expect(page).to have_content('Saldo Bônus 6')
    client_wallet.reload
    expect(client_wallet.bonus_balance).to eq(6)
  end

  it 'e tem o saldo bônus expirado após o deadline' do
    admin = create(:admin, status: :active)
    bonus_conversion = create(:bonus_conversion, percentage: 10, initial_date: 12.days.ago, final_date: 10.days.ago, admin: admin)
    category = create(:category, bonus_conversion: bonus_conversion)
    client_wallet = create(:client_wallet, bonus_balance: 6, category: category)
    create(:currency)
    credit = create(:credit, bonus_conversion: bonus_conversion, client_wallet: client_wallet, created_at: 11.days.ago)

    login_as(Admin.first)
    visit root_path
    click_on 'Carteiras de Clientes'
    click_on client_wallet.registered_number

    expect(page).to have_content('Saldo 76')
    expect(page).to have_content('Saldo Bônus 0')
    client_wallet.reload
    expect(client_wallet.bonus_balance).to eq(0)
  end

   it 'e tem o saldo bônus expirado após o deadline e não deixa o saldo negativo' do
     admin = create(:admin, status: :active)
     bonus_conversion = create(:bonus_conversion, percentage: 10, initial_date: 12.days.ago, final_date: 10.days.ago, admin: admin)
     category = create(:category, bonus_conversion: bonus_conversion)
     client_wallet = create(:client_wallet, bonus_balance: 3, category: category)
     create(:currency)
     create(:credit, bonus_conversion: bonus_conversion, client_wallet: client_wallet, created_at: 11.days.ago)
  
     login_as(Admin.first)
     visit root_path
     click_on 'Carteiras de Clientes'
     click_on client_wallet.registered_number
  
     expect(page).to have_content('Saldo 76')
     expect(page).to have_content('Saldo Bônus 0')
     client_wallet.reload
     expect(client_wallet.bonus_balance).to eq(0)
   end

end