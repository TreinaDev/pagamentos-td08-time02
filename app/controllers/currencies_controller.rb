class CurrenciesController < ApplicationController
  before_action :authenticate_admin!
  before_action :admin_active

  def index
    @currencies = Currency.all.order(created_at: :desc)
  end

  def new
    @currency = Currency.new
    @admin = current_admin
  end

  def create
    @admin = current_admin
    @currency = Currency.new(params.require(:currency).permit(:currency_value).merge(admin_id: @admin.id))
    
    @currency.save!
    redirect_to currencies_path, notice: 'Taxa de Câmbio criada com sucesso.'
  end

  private 

  def admin_active
    @admin = current_admin
    if !@admin.active?
      redirect_to root_path, notice: 'Você não tem acesso ao sistema. Aguarde a liberação para acessar a página.'
    end
  end
end