require 'rails_helper'

describe 'Admin registra limite de crédito diário' do
  it 'com sucesso' do
    admin = create(:admin, status: :active)

    login_as(admin)
    visit(root_path)
    click_on('Cadastrar limite de crédito diário')
    fill_in('Limite de crédito diário (R$)', with: 50_000)
    click_on('Salvar')

    expect(page).to have_content('Limite de crédito diário cadastrado com sucesso!')
    expect(page).to have_content('Limite de Crédito Diário: R$ 50.000,00')
  end

  it 'com campo incorreto' do
    admin = create(:admin, status: :active)

    login_as(admin)
    visit(root_path)
    click_on('Cadastrar limite de crédito diário')
    fill_in('Limite de crédito diário (R$)', with: '')
    click_on('Salvar')

    expect(page).to have_content('Limite de crédito diário não adicionado. Verifique os erros.')
    expect(page).to have_content('Limite de crédito diário (R$) não pode ficar em branco')
  end
end