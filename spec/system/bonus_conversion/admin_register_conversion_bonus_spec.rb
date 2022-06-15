require 'rails_helper'

describe 'Administrador acessa cadastro de conversão bônus' do
  it 'e cadastra a partir da home' do
    admin = create(:admin, status: :active)

    login_as(admin)
    visit(root_path)
    click_on('Conversões Bônus')
    click_on('Cadastrar nova conversão bônus')
    fill_in('Data inicial', with: Time.zone.today)
    fill_in('Data final', with: Time.zone.today + 10.days)
    fill_in('Percentual bônus', with: 10)
    fill_in('Prazo', with: 5)
    click_on('Cadastrar Conversão Bônus')

    expect(page).to have_current_path(admin_backoffice_bonus_conversions_path)
    expect(page).to have_content 'Conversão bônus cadastrada com sucesso!'
    within('thead') do
      expect(page).to have_css 'th', text: 'Data inicial'
      expect(page).to have_css 'th', text: 'Data final'
      expect(page).to have_css 'th', text: 'Percentual bônus'
      expect(page).to have_css 'th', text: 'Prazo para uso (dias)'
    end

    within('tbody') do
      expect(page).to have_css 'td', text: (I18n.l Time.zone.today).to_s
      expect(page).to have_css 'td', text: (I18n.l Time.zone.today + 10.days).to_s
      expect(page).to have_css 'td', text: '10%'
      expect(page).to have_css 'td', text: '5'
    end
    expect(page).to have_link('Voltar')
  end
end
