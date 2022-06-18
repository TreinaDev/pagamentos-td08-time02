class CreateBonusConversions < ActiveRecord::Migration[7.0]
  def change
    create_table :bonus_conversions do |t|
      t.datetime :initial_date
      t.datetime :final_date
      t.integer :percentage
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
