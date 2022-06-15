require 'rails_helper'

describe 'Administrador edita uma categoria existente' do
  it 'com sucesso' do
    admin = create(:admin, status: :active)
    category = create(:category)
    other_category = create(:category, name: 'Não VIP')

    login_as(admin)
    visit root_path
    click_on 'Categorias'
    within(".#{category.name.parameterize.underscore}") do
      click_on 'Editar'
    end
    fill_in 'Nome da categoria', with: 'Super VIP'
    fill_in 'Taxa fixa de desconto', with: 30
    click_on 'Salvar'

    expect(page).to have_content('Categoria: Super VIP')
    expect(page).to have_content('Taxa de Desconto: 30%')
  end

  it 'com dados inválidos' do
    admin = create(:admin, status: :active)
    category = create(:category)
    other_category = create(:category, name: 'Não VIP')

    login_as(admin)
    visit root_path
    click_on 'Categorias'
    within(".#{category.name.parameterize.underscore}") do
      click_on 'Editar'
    end
    fill_in 'Nome da categoria', with: ''
    fill_in 'Taxa fixa de desconto', with: 30
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível atualizar a categoria.')
    expect(page).to have_content('Nome da categoria não pode ficar em branco')
  end
end