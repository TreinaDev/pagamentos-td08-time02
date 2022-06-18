require 'rails_helper'

describe 'Administrador ativo acessa a plataforma' do
  it 'e faz login' do
    admin = Admin.create!(name: 'Fulano da Silva', password: '12345678', registration_number: '123.456.789-00',
                          email: 'admin@userubis.com.br', status: :active)

    visit root_path
    within('header') do 
     click_on 'Entrar'
    end
    
    within('form') do
      fill_in 'E-mail', with: 'admin@userubis.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Login'
    end

    expect(page).to have_current_path root_path
    expect(page).to have_link('Pagamentos')
  end

  it 'e faz logout' do
    admin = Admin.create!(name: 'Fulano da Silva', password: '12345678', registration_number: '123.456.789-00',
                          email: 'admin@userubis.com.br', status: :active)
    
    login_as(admin)
    visit root_path
    click_on 'Sair'

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Entrar'
  end
end
