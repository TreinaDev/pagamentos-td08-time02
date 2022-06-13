class ChangeAdminToCurrencies < ActiveRecord::Migration[7.0]
  def change
    rename_column :currencies, :admins_id, :admin_id
  end
end
