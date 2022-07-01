require 'rails_helper'

describe 'Administrador edita uma categoria existente' do
  it 'com sucesso' do
    admin = create(:admin, status: :active)
    create(:category)
    create(:category, name: 'Não VIP')

    login_as(admin)
    visit root_path
    click_on 'Categorias'
    click_on 'Editar', match: :first
    fill_in 'Nome da categoria', with: 'Super VIP'
    fill_in 'Taxa de Desconto', with: 30
    click_on 'Registrar'

    expect(page).to have_content('Categoria: Super VIP')
    expect(page).to have_content('Taxa de Desconto: 30%')
  end

  it 'com dados inválidos' do
    admin = create(:admin, status: :active)
    create(:category)
    create(:category, name: 'Não VIP')

    login_as(admin)
    visit root_path
    click_on 'Categorias'
    click_on 'Editar', match: :first
    fill_in 'Nome da categoria', with: ''
    fill_in 'Taxa de Desconto', with: 30
    click_on 'Registrar'

    expect(page).to have_content('Não foi possível atualizar a categoria.')
    expect(page).to have_content('Nome da categoria não pode ficar em branco')
  end

  it 'nome da categoria duplicada' do
    admin = create(:admin, status: :active)
    create(:category, name: 'Não VIP')
    create(:category)

    login_as(admin)
    visit root_path
    click_on 'Categorias'
    within('div:first.category-container') do
      click_on 'Editar', match: :first
    end

    fill_in 'Nome da categoria', with: 'VIP'
    fill_in 'Taxa de Desconto', with: 30
    click_on 'Registrar'

    expect(page).to have_content('Não foi possível atualizar a categoria.')
    expect(page).to have_content('Nome da categoria já está em uso')
  end

  it 'enquanto o seu status é inativo' do
    admin = create(:admin, status: :inactive)
    category = create(:category)
    create(:category, name: 'Outra Categoria')

    login_as(admin)
    visit edit_admin_backoffice_category_path(category.id)

    expect(page).to have_current_path(new_admin_session_path)
  end

  it 'enquanto o seu status é pendente' do
    admin = create(:admin, status: :pending)
    category = create(:category)
    create(:category, name: 'Outra Categoria')

    login_as(admin)
    visit edit_admin_backoffice_category_path(category.id)

    expect(page).to have_current_path(new_admin_session_path)
  end

  it 'e não está logado' do
    category = create(:category)

    visit edit_admin_backoffice_category_path(category.id)

    expect(page).to have_current_path(new_admin_session_path)
  end
end
