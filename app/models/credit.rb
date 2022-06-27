class Credit < ApplicationRecord
  belongs_to :bonus_conversion, optional: true
  belongs_to :client_wallet
  after_create :check_for_bonus_conversion
  validates :value, presence: true
  validates :value, numericality: { greater_than: 0 }

  private

  def check_for_bonus_conversion
    if client_wallet.category.bonus_conversion.nil?
      client_wallet.balance += (value / Currency.active.last.currency_value * 100).to_i
      client_wallet.save
    else
      apply_credit_with_bonus_conversion
    end
  end

  def apply_credit_with_bonus_conversion
    bonus_conversion = client_wallet.category.bonus_conversion
    rubi_value = ((value / Currency.active.last.currency_value) * 100).to_i 
    client_wallet.balance += rubi_value
    if DateTime.now <= bonus_conversion.final_date
      client_wallet.bonus_balance += self.bonus_balance = rubi_value * bonus_conversion.percentage / 100
    end
    client_wallet.save
  end
end
