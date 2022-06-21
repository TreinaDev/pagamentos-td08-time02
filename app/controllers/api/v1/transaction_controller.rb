class Api::V1::TransactionController < Api::V1::ApiController
  def create
    transaction = Transaction.new(transaction_params)

    if transaction.save
      render status: :created, json: transaction
    else
      render status: :precondition_failed, json: { errors: transaction.errors.full_messages }
    end
  end

  private

  def transaction_params
    transaction_params = params.require(:transaction).permit(:registered_number, :value, :currency_rate,
                                                             :transaction_type)
  end
end
