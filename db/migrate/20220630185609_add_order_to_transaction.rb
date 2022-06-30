class AddOrderToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :order, :string
  end
end
