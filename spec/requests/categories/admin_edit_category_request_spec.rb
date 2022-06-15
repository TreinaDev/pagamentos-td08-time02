require 'rails_helper'

describe 'Administrador edita uma categoria' do
  it 'com sucesso' do
    admin = create(:admin, status: :active)
    categoria = create(:category)

    login_as(admin)
    patch(admin_backoffice_category_path(categoria.id), params: { category: { name: 'Padrão', discount: 0 } })

    expect(response).to redirect_to(admin_backoffice_categories_path)
  end

  it 'sem estar autenticado' do
    admin = create(:admin)
    categoria = create(:category)

    login_as(admin)
    patch(admin_backoffice_category_path(categoria.id), params: { category: { name: 'Padrão', discount: 0 } })

    expect(response).to redirect_to(new_admin_session_path)
  end

  it 'sem estar logado' do
    categoria = create(:category)

    patch(admin_backoffice_category_path(categoria.id), params: { category: { name: 'Padrão', discount: 0 } })

    expect(response).to redirect_to(new_admin_session_path)
  end
end