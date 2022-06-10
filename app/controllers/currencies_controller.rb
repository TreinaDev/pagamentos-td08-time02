class CurrenciesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @currencies = Currency.all
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
end