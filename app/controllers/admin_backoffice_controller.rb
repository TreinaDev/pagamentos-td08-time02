class AdminBackofficeController < ApplicationController
  rescue_from Errno::ECONNREFUSED, with: :connection_refused
  before_action :authenticate_admin!

  def connection_refused
    flash[:notice] = 'Ação realizada com sucesso, porém a conexão com o e-commerce não ocorreu!'
  end
end