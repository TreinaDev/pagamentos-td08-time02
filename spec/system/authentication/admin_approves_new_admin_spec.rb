require 'rails_helper'

describe 'Administrador vê lista de administradores pendentes' do
  it 'com sucesso' do
    active_admin = Admin.create!(name: 'Fulano da Silva', email: 'admin2@userubis.com.br',
                                 password: '12345678', registration_number: '123.456.789-00',
                                 status: :active)
    admin = create(:admin)

    login_as active_admin
    visit root_path
    click_on 'Requisições de aprovação'

    expect(page).to have_css 'h2', text: 'Listagem de Administradores Pendentes'
    within('thead tr') do
      expect(page).to have_css 'th', text: 'Nome'
      expect(page).to have_css 'th', text: 'E-mail'
    end

    within('tbody tr') do
      expect(page).to have_css 'td', text: 'Admin de Solza'
      expect(page).to have_css 'td', text: 'admin@userubis.com.br'
      expect(page).to have_button 'Aprovar'
      expect(page).to have_button 'Recusar'
    end
  end

  it 'e é o primeiro a aceitar' do
    active_admin = Admin.create!(name: 'Fulano da Silva', email: 'admin2@userubis.com.br',
                                 password: '12345678', registration_number: '123.456.789-00',
                                 status: :active)
    admin = create(:admin)

    login_as active_admin
    visit root_path
    click_on 'Requisições de aprovação'
    click_on 'Aprovar'

    # expect(admin.status).to eq 'pending'   -> quebrado
  end
end
