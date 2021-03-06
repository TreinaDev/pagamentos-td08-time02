class Api::V1::CreditsController < Api::V1::ApiController
  before_action :credit_params

  def create
    if Currency.active.any?
      save_credit
    else
      render status: :not_found, json: { error: 'Não há uma taxa de câmbia ativa' }
    end
  end

  private

  def credit_params
    params.require(:credit).permit(:registered_number, :value)
  end

  def save_credit
    client_wallet = ClientWallet.find_by(registered_number: credit_params[:registered_number])
    credit = Credit.new(value: credit_params[:value], client_wallet:)
    if credit.save
      if credit.accepted?
        render status: :created, json: {status: 'approved', message: 'Crédito aprovado'}
      else
        render status: :created, json: {status: 'pending', message: 'Crédito acima do limite permitido. Aguardando aprovação.'}
      end
    else
      render status: :precondition_failed, json: { errors: credit.errors.full_messages }
    end
  end
end
