class AddStatusToAdmin < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :status, :integer, default: 0
  end
end
