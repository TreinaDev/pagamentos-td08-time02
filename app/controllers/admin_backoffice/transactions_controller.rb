class AdminBackoffice::TransactionsController < AdminBackofficeController
  before_action :set_params, only: %i[approve refuse edit update]

  def index
    @transactions = Transaction.order(created_at: :desc)
  end

  def approve
    @transaction.accepted!
    redirect_to admin_backoffice_transactions_path, notice: t(:approval_transaction)
  end

  def refuse
    @transaction.rejected!
    redirect_to edit_admin_backoffice_transaction_path(@transaction.id)
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