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
end
