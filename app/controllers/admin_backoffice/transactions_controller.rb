class AdminBackoffice::TransactionsController < AdminBackofficeController
  def index
    @transactions = Transaction.all
  end
end