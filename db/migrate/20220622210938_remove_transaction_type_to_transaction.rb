class RemoveTransactionTypeToTransaction < ActiveRecord::Migration[7.0]
  def change
    remove_column :transactions, :transaction_type
  end
end
