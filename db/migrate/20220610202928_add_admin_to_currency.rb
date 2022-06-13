class AddAdminToCurrency < ActiveRecord::Migration[7.0]
  def change
    add_reference :currencies, :admins, null: false, foreign_key: true
  end
end
