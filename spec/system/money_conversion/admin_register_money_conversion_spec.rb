require 'rails_helper'

describe 'Administrador cadastra uma taxa de câmbio' do
  it 'com sucesso a partir da tela inicial' do
    admin = create(:admin)

    login_as(admin)
    visit root_path
    click_on 'Taxa de Câmbio'
    click_on 'Cadastrar nova Taxa'

    fill_in 'Valor de um Rubi em Reais', with: 1.5
    click_on 'Salvar'

    expect(page).to have_content 'Taxas de Câmbio'
    expect(page).to have_content 'Valor de um Rubi é 1.5 Reais'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content 'Status: active'
  end

  it 'e vê lista de taxas de câmbio cadastradas' do
    admin = create(:admin)
    currency = create(:currency)

    login_as admin
    visit root_path
    click_on 'Taxa de Câmbio'
    click_on 'Cadastrar nova Taxa'

    fill_in 'Valor de um Rubi em Reais', with: 3
    click_on 'Salvar'
    
    expect(page).to have_content 'Taxas de Câmbio'
    expect(page).to have_content 'Valor de um Rubi é 1.5 Reais'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content 'Status: inactive'
    expect(page).to have_content 'Valor de um Rubi é 3.0 Reais'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content 'Status: active'
  end
end