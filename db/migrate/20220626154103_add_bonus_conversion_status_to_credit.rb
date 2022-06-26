class AddBonusConversionStatusToCredit < ActiveRecord::Migration[7.0]
  def change
    add_column :credits, :bonus_conversion_status, :integer, default: 2
  end
end
