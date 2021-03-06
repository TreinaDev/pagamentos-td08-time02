require 'rails_helper'

describe 'Administrador cadastra uma taxa de câmbio' do
  it 'com sucesso a partir da tela inicial' do
    admin = create(:admin)
    admin.active!

    login_as(admin)
    visit root_path
    click_on 'Taxa de Câmbio'
    click_on 'Nova Taxa'
    fill_in 'Valor do Rubi', with: 1.5
    click_on 'Salvar'

    expect(page).to have_content 'Taxa de Câmbio'
    expect(page).to have_content 'Valor do Rubi: R$ 1,50'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content "Criado em: #{I18n.l Time.zone.today}"
    expect(page).to have_content 'Status: Aceito'
  end

  it 'e vê lista de taxas de câmbio cadastradas' do
    admin = create(:admin)
    admin.active!
    create(:currency)

    login_as(admin)
    visit root_path
    click_on 'Taxa de Câmbio'
    click_on 'Nova Taxa'
    fill_in 'Valor do Rubi', with: 1.6
    click_on 'Salvar'

    expect(page).to have_content 'Taxas de Câmbio'
    expect(page).to have_content 'Valor do Rubi: R$ 1,50'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content 'Status: Aceito'
    expect(page).to have_content 'Valor do Rubi: R$ 1,60'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content 'Status: Aceito'
  end

  it 'e vê inactivo quando criado a mais de 3 dias' do
    admin = create(:admin)
    admin.active!
    currency = create(:currency)
    currency.created_at = 5.days.ago
    currency.save!

    login_as(admin)
    visit root_path
    click_on 'Taxa de Câmbio'

    expect(page).to have_content 'Status: Inativo'
  end

  it 'se for 10% maior que a taxa anterior, status fica pendente e espera aprovação' do
    admin = create(:admin)
    admin.active!
    create(:currency)

    login_as(admin)
    visit(root_path)
    click_on 'Taxa de Câmbio'
    click_on 'Nova Taxa'
    fill_in 'Valor do Rubi', with: 1.66
    click_on 'Salvar'

    expect(page).to have_content 'Taxa criada é 10% maior que a anterior. Esperando aprovação de outro administrador.'
    expect(page).to have_content 'Taxas de Câmbio'
    expect(page).to have_content 'Valor do Rubi: R$ 1,66'
    expect(page).to have_content 'Usuário Responsável: Admin de Solza'
    expect(page).to have_content 'Status: Pendente'
  end

  it 'e cria uma taxa enquanto outra estiver pendente' do
    admin = create(:admin)
    admin.active!
    create(:currency)
    create(:currency, currency_value: 3)

    login_as(admin)
    visit root_path
    click_on 'Taxa de Câmbio'

    expect(page).not_to have_link 'Cadastrar nova Taxa'
    expect(page).to have_content 'Status: Pendente'
  end
end
