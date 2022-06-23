class AdminBackoffice::TransactionsController < AdminBackofficeController
  def index
    @transactions = Transaction.all
  end

  def approve
    @transaction = Transaction.find(params[:id])
    @transaction.accepted!
    redirect_to admin_backoffice_transactions_path, notice: t(:approval_transaction)
  end

  def refuse
    @transaction = Transaction.find(params[:id])
    @transaction.rejected!
    redirect_to admin_backoffice_transactions_path, notice: t(:refuse_transaction)
  end
end