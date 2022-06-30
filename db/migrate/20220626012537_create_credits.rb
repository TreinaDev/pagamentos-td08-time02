class CreateCredits < ActiveRecord::Migration[7.0]
  def change
    create_table :credits do |t|
      t.integer :value
      t.references :bonus_conversion, null: true, foreign_key: true
      t.references :client_wallet, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
