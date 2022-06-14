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
end