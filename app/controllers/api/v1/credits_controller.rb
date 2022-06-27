class Api::V1::CreditsController < Api::V1::ApiController
  before_action :credit_params

  def create
    client_wallet = ClientWallet.find_by(registered_number: credit_params[:registered_number])
    credit = Credit.new(value: credit_params[:value], client_wallet: client_wallet)
    if credit.save
      render status: :created, json: {status: 'approved', message: 'Transação aprovada'}
    else
      render status: :precondition_failed, json: { errors: credit.errors.full_messages }
    end
  end

  private

  def credit_params
    params.require(:credit).permit(:registered_number, :value)
  end
end