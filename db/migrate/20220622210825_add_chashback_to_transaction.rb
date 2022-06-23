class AddChashbackToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :cashback, :integer
  end
end
