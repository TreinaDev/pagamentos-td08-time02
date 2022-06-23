require 'rails_helper'

describe 'Administrador cadastra categoria de cliente nova' do
  it 'com sucesso' do
    admin = create(:admin, status: :active)
    create(:bonus_conversion, admin: admin)

    login_as(admin)
    visit root_path

    click_on 'Categorias'
    click_on 'Adicionar nova categoria'

    fill_in 'Nome da categoria', with: 'Genérica'
    fill_in 'Taxa de Desconto', with: 3 
    select '1', from: 'Conversão Bônus'
    click_on 'Registrar'

    expect(page).to have_content('Categoria adicionada com sucesso.')
    expect(page).to have_content('Categoria: Genérica')
    expect(page).to have_content('Taxa de Desconto: 3%')
    expect(page).to have_content('Conversão Bônus: 1%')
  end

  it 'com informações inválidas' do
    admin = create(:admin, status: :active)

    login_as(admin)
    visit new_admin_backoffice_category_path

    fill_in 'Nome da categoria', with: ''
    fill_in 'Taxa de Desconto', with: 3
    click_on 'Registrar'

    expect(page).to have_content('Não foi possível criar a categoria')
    expect(page).to have_content('Verifique os erros abaixo')
    expect(page).to have_content('Nome da categoria não pode ficar em branco')
  end

  it 'enquanto seu status está pendente' do
    admin = create(:admin, status: :pending)

    login_as(admin)
    visit new_admin_backoffice_category_path

    expect(page).to have_current_path(new_admin_session_path)
  end

  it 'enquanto seu status está inativo' do
    admin = create(:admin, status: :inactive)

    login_as(admin)
    visit new_admin_backoffice_category_path

    expect(page).to have_current_path(new_admin_session_path)
  end
  
  it 'e não está logado' do
    visit new_admin_backoffice_category_path

    expect(page).to have_current_path(new_admin_session_path)
  end
end