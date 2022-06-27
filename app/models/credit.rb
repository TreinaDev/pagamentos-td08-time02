class Credit < ApplicationRecord
  belongs_to :bonus_conversion, optional: true
  belongs_to :client_wallet 
  after_create :check_for_bonus_conversion
  validates :value, presence: true
  validates :value, numericality: {greater_than: 0}

  private

  def check_for_bonus_conversion
    if client_wallet.category.bonus_conversion.nil?
      client_wallet.balance += (value / Currency.active.last.currency_value).to_i
      client_wallet.save
    else
      bonus_conversion = client_wallet.category.bonus_conversion
      ruby_value = (value / Currency.active.last.currency_value).to_i
      client_wallet.balance += ruby_value
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
