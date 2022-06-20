class AddBonusConversionToCategory < ActiveRecord::Migration[7.0]
  def change
    add_reference :categories, :bonus_conversion, null: true, foreign_key: true
  end
end
