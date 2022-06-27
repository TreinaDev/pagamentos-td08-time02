class CreateCreditLimits < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_limits do |t|
      t.integer :max_limit

      t.timestamps
    end
  end
end
