require 'rails_helper'

describe 'Administrador acessa página de créditos pendentes' do

  it 'e visualiza os créditos pendentes' do
    admin = create(:admin, status: :active)
    client_wallet = create(:client_wallet)
    create(:credit, status: :pending, value: 200, client_wallet:, bonus_conversion: nil)

    login_as(admin)
    visit(root_path)
    click_on('Crédito Pendente')

    expect(page).to have_css 'th', text: 'CPF ou CNPJ'
    expect(page).to have_css 'th', text: 'Valor'
    expect(page).to have_css 'td', text: 'R$ 200,00'
    expect(page).to have_css 'td', text: '111.111.111-11'
    expect(page).to have_button('Aprovar')
    expect(page).to have_button('Recusar')
  end

  it 'aprova crédito com sucesso' do
    admin = create(:admin, status: :active)
    create(:currency)
    client_wallet = create(:client_wallet)
    create(:credit, value: 200, status: :pending, bonus_conversion: nil, client_wallet:)

    login_as(admin)
    visit(root_path)
    click_on('Crédito Pendente')
    click_on('Aprovar')

    expect(page).to have_current_path(admin_backoffice_credits_path)
    expect(page).to have_content('Não existem créditos pendentes no momento')
    expect(page).not_to have_content('Crédito pendente: R$ 200,00')
    expect(page).not_to have_content("CPF: #{client_wallet.registered_number}")
    client_wallet.reload
    expect(client_wallet.balance).to eq(13343)
  end

  it 'rejeita crédito com sucesso' do
    admin = create(:admin, status: :active)
    create(:currency)
    client_wallet = create(:client_wallet)
    create(:credit, value: 200, status: :pending, bonus_conversion: nil, client_wallet:)

    login_as(admin)
    visit(root_path)
    click_on('Crédito Pendente')
    click_on('Recusar')

    expect(page).to have_current_path(admin_backoffice_credits_path)
    expect(page).to have_content('Não existem créditos pendentes no momento')
    expect(page).to have_content('Crédito rejeitado com sucesso!')
    expect(page).not_to have_content('Crédito pendente: R$ 200,00')
    expect(page).not_to have_content("CPF: #{client_wallet.registered_number}")
    client_wallet.reload
    expect(client_wallet.balance).to eq(10)
  end

  it 'e aprova um crédito com conversão bônus' do
    admin = create(:admin, status: :active)
    bonus_conversion = create(:bonus_conversion, percentage: 10, admin:)
    currency = create(:currency)
    client_wallet = create(:client_wallet, category: create(:category, bonus_conversion:))
    credit = create(:credit, value: 200, client_wallet:, bonus_conversion:, status: :pending)

    login_as(admin)
    visit root_path
    click_on('Crédito Pendente')
    click_on('Aprovar')

    expect(page).to have_current_path(admin_backoffice_credits_path)
    expect(page).to have_content('Não existem créditos pendentes no momento')
    expect(page).to have_content('Crédito aprovado com sucesso!')
    expect(page).not_to have_content('Crédito pendente: R$ 200,00')
    expect(page).not_to have_content("CPF: #{client_wallet.registered_number}")
    client_wallet.reload
    expect(client_wallet.balance).to eq(13343)
    expect(client_wallet.bonus_balance).to eq(1333)
  end
end