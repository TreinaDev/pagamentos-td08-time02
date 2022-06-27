class RemoveBonusConversionStatusFromCredit < ActiveRecord::Migration[7.0]
  def change
    remove_column :credits, :bonus_conversion_status, :integer
  end
end
