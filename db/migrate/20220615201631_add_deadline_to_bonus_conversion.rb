class AddDeadlineToBonusConversion < ActiveRecord::Migration[7.0]
  def change
    add_column :bonus_conversions, :deadline, :integer
  end
end
