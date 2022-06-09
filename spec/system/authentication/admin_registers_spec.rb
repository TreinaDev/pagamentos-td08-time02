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

  it 'com sucesso' do
    visit new_admin_registration_path

    fill_in 'Nome completo', with: 'Admin de Sousa'
    fill_in 'CPF', with: '000.000.000-00'
    fill_in 'E-mail', with: 'admin@userubis.com.br'
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirmação de senha', with: '12345678'
    click_on 'Cadastrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
    expect(page).to have_content 'Aguarde a aprovação para poder usar a plataforma'
    within('header') do
      expect(page).to have_content 'admin@userubis.com.br'
      expect(page).to have_content 'Admin de Sousa'
      expect(page).to have_button 'Sair'
    end
  end
end
