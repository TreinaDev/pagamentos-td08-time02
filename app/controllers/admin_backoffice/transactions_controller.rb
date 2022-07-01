class AdminBackoffice::TransactionsController < AdminBackofficeController
  before_action :set_params, only: %i[approve refuse edit update]

  def index
    @transactions = Transaction.all
  end

  def approve
    @transaction.accepted!
    redirect_to admin_backoffice_transactions_path, notice: t(:approval_transaction)
    params = { code: @transaction.order, status: :approved, message: @transaction.message }
    Faraday.post('http://localhost:3000/api/v1/purchases/update-status', params)
  end

  def refuse
    @transaction.rejected!
    redirect_to edit_admin_backoffice_transaction_path(@transaction.id)
    params = { code: @transaction.order, status: :rejected, message: @transaction.message }
    Faraday.post('http://localhost:3000/api/v1/purchases/update-status', params)
  end

  def edit; end

  def update
    if @transaction.update(transaction_params)
      redirect_to admin_backoffice_transactions_path, notice: t(:transaction_successfully_updated)
    else
      flash.now[:message] = t(:transaction_rejected_update)
      render :edit
    end
  end

  private

  def set_params
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:message)
  end
end