class Api::V1::CreditsController < Api::V1::ApiController
  before_action :credit_params

  def create
    client_wallet = ClientWallet.find_by(registered_number: credit_params[:registered_number])
    client_wallet.balance += ((credit_params[:value]).to_f / Currency.active.first.currency_value).to_i
    client_wallet.save!
    render status: 201, json: {status: 'approved', message: 'Transação aprovada'}
  end

  private

  def credit_params
    params.require(:credit).permit(:registered_number, :value)
  end
end