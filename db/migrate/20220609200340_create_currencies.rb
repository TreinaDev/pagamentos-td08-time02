class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies do |t|
      t.integer :status, default: 0
      t.float :currency_value

      t.timestamps
    end
  end
end
