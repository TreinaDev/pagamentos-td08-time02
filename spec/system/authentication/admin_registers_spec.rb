require 'rails_helper'

describe 'Administrador faz login' do
  it 'a partir da tela inicial' do
    visit root_path
    click_on 'Registrar-se'

    expect(current_path).to eq(new_admin_registration_path)
    within('form') do
      expect(page).to have_field('Nome completo')
      expect(page).to have_field('CPF')
      expect(page).to have_field('E-mail')
      expect(page).to have_field('Senha')
    end
  end

  it 'com dados incompletos' do
    visit new_admin_registration_path

    fill_in 'Nome completo', with: ''
    fill_in 'CPF', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: 'password'
    click_on 'Cadastrar'

    expect(page).to have_content('Não foi possível salvar administrador')
    expect(page).to have_content('Nome completo não pode ficar em branco')
    expect(page).to have_content('CPF não pode ficar em branco')
    expect(page).to have_content('E-mail não pode ficar em branco')
  end
end
