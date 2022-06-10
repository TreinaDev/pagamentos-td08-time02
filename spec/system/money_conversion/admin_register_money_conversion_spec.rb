require 'rails_helper'

describe 'Administrador cadastra uma taxa de câmbio' do
  it 'a partir da tela inicial' do
    # Adicionar administrador assim que a feature dele estiver pronta
    admin = create(:admin)

    login_as(admin)
    visit root_path
    click_on 'Taxa de Câmbio'
    click_on 'Cadastrar nova Taxa'

    fill_in 'Valor de um Rubi em Reais', with: 1.5
    click_on 'Salvar'

    expect(page).to have_content 'Taxas de Câmbio'
    expect(page).to have_content 'Valor de um Rubi é 1.5 Reais'
    expect(page).to have_content 'Status: active'
  end
end