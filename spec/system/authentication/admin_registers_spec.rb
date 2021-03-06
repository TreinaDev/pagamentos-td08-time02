require 'rails_helper'

describe 'Administrador faz cadastro' do
  it 'com sucesso' do
    visit root_path
    click_on 'Registrar-se'

    fill_in 'Nome completo', with: 'Admin de Sousa'
    fill_in 'CPF', with: '000.000.000-00'
    fill_in 'E-mail', with: 'admin@userubis.com.br'
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirme a senha', with: '12345678'
    click_on 'Cadastrar'

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Você se inscreveu com sucesso, porém nós não podemos autenticá-lo porque sua conta ainda não foi ativada.'
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
