class AddBonusBalanceToCredit < ActiveRecord::Migration[7.0]
  def change
    add_column :credits, :bonus_balance, :integer, default: 0
  end
end
