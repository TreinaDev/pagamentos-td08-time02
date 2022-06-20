class CreateClientWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :client_wallets do |t|
      t.string :registered_number
      t.string :email
      t.integer :balance, default: 0
      t.integer :bonus_balance, default: 0
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
