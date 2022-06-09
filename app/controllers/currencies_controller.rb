class CurrenciesController < ApplicationController
  def index
    @currencies = Currency.all
  end

  def new
    @currency = Currency.new
  end

  def create
    @currency = Currency.new(params.require(:currency).permit(:currency_value))
    
    @currency.save!
    redirect_to currencies_path, notice: 'Taxa de Câmbio criada com sucesso.'
  end
end