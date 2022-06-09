class AddFieldsToAdmin < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :name, :string
    add_column :admins, :registration_number, :string
  end
end
