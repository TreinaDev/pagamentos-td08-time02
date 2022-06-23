class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :value
      t.string :registered_number
      t.integer :transaction_type
      t.integer :status, default: 0
      t.float :currency_rate

      t.timestamps
    end
  end
end
