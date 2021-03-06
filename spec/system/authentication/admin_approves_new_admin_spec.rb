require 'rails_helper'

describe 'Administrador vê lista de administradores pendentes' do
  it 'com sucesso' do
    active_admin = Admin.create!(name: 'Fulano da Silva', email: 'admin2@userubis.com.br',
                                 password: '12345678', registration_number: '123.456.789-00',
                                 status: :active)
    create(:admin, status: :inactive)

    login_as active_admin
    visit root_path
    click_on 'Administradores Pendentes'

    expect(page).to have_css 'h2', text: 'Listagem de Administradores Pendentes'
    within('thead') do
      expect(page).to have_css 'th', text: 'Nome'
      expect(page).to have_css 'th', text: 'E-mail'
    end

    within('tbody') do
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

    admin = create(:admin, status: :inactive)

    login_as active_admin
    visit root_path
    click_on 'Administradores Pendentes'
    click_on 'Aprovar', match: :first
    admin.reload

    expect(admin.status).to eq 'pending'
  end

  it 'e não vê o botão caso já tenha aprovado um administrador pendente' do
    active_admin = Admin.create!(name: 'Fulano da Silva', email: 'admin2@userubis.com.br',
                                 password: '12345678', registration_number: '123.456.789-00',
                                 status: :active)
    create(:admin)

    login_as(active_admin)
    visit admin_backoffice_pending_admins_path
    click_on 'Aprovar'
    expect(page).to have_current_path(admin_backoffice_pending_admins_path)
    expect(page).not_to have_button('Aprovar')
    expect(page).not_to have_button('Recusar')
  end

  it 'e é o segundo a aceitar' do
    active_admin = Admin.create!(name: 'Fulano da Silva', email: 'admin2@userubis.com.br',
                                 password: '12345678', registration_number: '123.456.789-00',
                                 status: :active)

    admin = Admin.create(name: 'Beltrano da Silva', email: 'admin@userubis.com.br', password: '12345678',
                         registration_number: '000.000.000-00', status: :pending)

    login_as active_admin
    visit root_path
    click_on 'Administradores Pendentes'
    click_on 'Aprovar'

    admin.reload

    expect(admin.status).to eq 'active'
  end

  it 'e recusa um administrador' do
    active_admin = Admin.create!(name: 'Fulano da Silva', email: 'admin2@userubis.com.br',
                                 password: '12345678', registration_number: '123.456.789-00',
                                 status: :active)

    admin = create(:admin)

    login_as active_admin
    visit root_path
    click_on 'Administradores Pendentes'
    click_on 'Recusar'

    admin.reload

    expect(admin.status).to eq 'refused'
  end

  it 'e não vê nada se não estiver logado' do
    visit admin_backoffice_pending_admins_path

    expect(page).to have_current_path(new_admin_session_path)
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end
end
