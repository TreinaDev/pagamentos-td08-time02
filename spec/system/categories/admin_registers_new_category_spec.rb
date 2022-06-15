require 'rails_helper'

describe 'Administrador cadastra categoria de cliente nova' do
  it 'com sucesso' do
    admin = create(:admin, status: :active)

    login_as(admin)
    visit root_path

    click_on 'Categorias'
    click_on 'Adicionar nova categoria'

    fill_in 'Nome da categoria', with: 'Genérica'
    fill_in 'Taxa fixa de desconto', with: 3
    click_on 'Registrar'

    expect(page).to have_content('Categoria adicionada com sucesso.')
    expect(page).to have_content('Categoria: Genérica')
    expect(page).to have_content('Taxa de Desconto: 3%')
  end

  it 'com informações inválidas' do
    admin = create(:admin, status: :active)

    login_as(admin)
    visit new_admin_backoffice_category_path

    fill_in 'Nome da categoria', with: ''
    fill_in 'Taxa fixa de desconto', with: 3
    click_on 'Registrar'

    expect(page).to have_content('Não foi possível criar a categoria')
    expect(page).to have_content('Verifique os erros abaixo')
    expect(page).to have_content('Nome da categoria não pode ficar em branco')
  end
end