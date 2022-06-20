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
end