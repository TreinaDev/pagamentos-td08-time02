require 'rails_helper'

describe 'Administrador cadastra uma taxa de câmbio' do
  it 'e não é um administrador ativo' do
    admin = create(:admin)

    login_as(admin)
    visit root_path
    click_on 'Taxa de Câmbio'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso ao sistema. Aguarde a liberação para acessar a página.'
  end

  it 'com sucesso a partir da tela inicial' do
    admin = create(:admin)
    admin.active!

    login_as(admin)
    visit root_path
    click_on 'Taxa de Câmbio'
    click_on 'Cadastrar nova Taxa'
    fill_in 'Valor de um Rubi em Reais', with: 1.5
    click_on 'Salvar'

    expect(page).to have_content 'Taxas de Câmbio'
    expect(page).to have_content 'Valor de um Rubi é 1.5 Reais'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content 'Criado dia: 11/06/2022'
    expect(page).to have_content 'Status: active'
  end

  it 'e vê lista de taxas de câmbio cadastradas' do
    admin = create(:admin)
    admin.active!
    currency = create(:currency)

    login_as(admin)
    visit root_path
    click_on 'Taxa de Câmbio'
    click_on 'Cadastrar nova Taxa'
    fill_in 'Valor de um Rubi em Reais', with: 1.6
    click_on 'Salvar'
    
    expect(page).to have_content 'Taxas de Câmbio'
    expect(page).to have_content 'Valor de um Rubi é 1.5 Reais'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content 'Status: inactive'
    expect(page).to have_content 'Valor de um Rubi é 1.6 Reais'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content 'Status: active'
  end

  it 'e vê inactivo quando criado a mais de 3 dias' do
    admin = create(:admin)
    admin.active!
    currency = create(:currency)
    currency.created_at = 5.days.ago
    currency.save!

    login_as(admin)
    visit root_path
    click_on "Taxa de Câmbio"

    expect(page).to have_content 'Status: inactive'
  end

  it 'se for 10% maior que a taxa anterior, status fica pendente e espera aprovação' do
    admin = create(:admin)
    admin.active!
    currency = create(:currency)

    login_as(admin)
    visit(root_path)
    click_on 'Taxa de Câmbio'
    click_on 'Cadastrar nova Taxa'
    fill_in 'Valor de um Rubi em Reais', with: 1.66
    click_on 'Salvar'
    
    expect(page).to have_content 'Taxa criada é 10% maior que a anterior. Esperando aprovação de outro administrador.'
    expect(page).to have_content 'Taxas de Câmbio'
    expect(page).to have_content 'Valor de um Rubi é 1.66 Reais'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content 'Status: pending'
  end
end