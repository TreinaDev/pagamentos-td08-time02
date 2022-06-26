class Credit < ApplicationRecord
  belongs_to :bonus_conversion, optional: true
  belongs_to :client_wallet
  enum bonus_conversion_status: { active: 0, inactive: 2} 
  after_create :check_for_bonus_conversion
  # after_find :check_for_active

  private

  # def check_for_active
  #   credit_deadline = (created_at.to_date + bonus_conversion.deadline.days)
  #   if self.active? && credit_deadline < Time.zone.now.to_date
  #     sql = "UPDATE credits SET bonus_conversion_status=2 WHERE id=#{self.id}"
  #     ActiveRecord::Base.connection.execute(sql) 
  #   end
  # end

  def check_for_bonus_conversion
    if client_wallet.category.bonus_conversion.nil?
      client_wallet.balance += (value / Currency.active.last.currency_value).to_i
      client_wallet.save
    else
      bonus_conversion = client_wallet.category.bonus_conversion
      ruby_value = (value / Currency.active.last.currency_value).to_i
      client_wallet.balance += ruby_value
      self.active!
      self.bonus_balance = ((ruby_value * bonus_conversion.percentage) * 0.01).to_i 
      self.save
      if DateTime.now <= bonus_conversion.final_date
        client_wallet.bonus_balance += ((ruby_value * bonus_conversion.percentage) * 0.01).to_i
        client_wallet.save
      else
        client_wallet.save
      end
    end
  end
end
