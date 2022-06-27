class AddMessageToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :message, :text
  end
end
