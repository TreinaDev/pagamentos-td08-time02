class Api::V1::TransactionsController < Api::V1::ApiController
  def show
    transaction = Transaction.find_by(order: params[:id])
    raise ActiveRecord::RecordNotFound if transaction.nil?

    render status: :ok, json: transaction.as_json(only: %i[registered_number status order message])
  end

  def create
    transaction = Transaction.new(transaction_params)

    if transaction.save
      render status: :created, json: { status: transaction.status,
                                       message: 'Transação realizada com sucesso!' }
    else
      render status: :precondition_failed, json: { errors: transaction.errors.full_messages }
    end
  end

  private

  def transaction_params
    currency = Currency.active.last
    params.require(:transaction)
          .permit(:registered_number, :value, :cashback, :order)
          .merge(currency_rate: currency.currency_value)
  end
end
