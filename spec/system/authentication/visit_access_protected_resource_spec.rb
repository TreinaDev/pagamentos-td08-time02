require 'rails_helper'

describe 'Visitante tenta acessar a listagem de taxas de câmbio' do
  it 'mas não tem acesso de administrador' do
    visit admin_backoffice_currencies_path

    expect(page).to have_current_path new_admin_session_path
  end
end
