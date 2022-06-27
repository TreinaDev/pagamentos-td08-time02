class Credit < ApplicationRecord
  belongs_to :bonus_conversion, optional: true
  belongs_to :client_wallet 
  after_create :check_daily_credit_limit 
  after_create :check_for_bonus_conversion
  validates :value, presence: true
  validates :value, numericality: {greater_than: 0}
  enum status: { pending: 2, accepted: 0, refused: 4 }

  private

  def check_for_bonus_conversion
    if self.accepted?
      if client_wallet.category.bonus_conversion.nil?
        client_wallet.balance += (value / Currency.active.last.currency_value).to_i
      else
        bonus_conversion = client_wallet.category.bonus_conversion
        ruby_value = (value / Currency.active.last.currency_value).to_i
        client_wallet.balance += ruby_value
        self.bonus_balance = ((ruby_value * bonus_conversion.percentage) * 0.01).to_i 
        self.save
        if DateTime.now <= bonus_conversion.final_date
          client_wallet.bonus_balance += ((ruby_value * bonus_conversion.percentage) * 0.01).to_i
        end
      end
      accepted!
      client_wallet.save
    end
  end

  def check_daily_credit_limit
    daily_credit_limit = CreditLimit.last.max_limit if CreditLimit.all.any?
    unless daily_credit_limit.nil?
      credits = Credit.where(client_wallet: client_wallet).where("created_at >= :start_date AND created_at <= :end_date", {start_date: Time.zone.today.midnight, end_date: (Time.zone.tomorrow.midnight - 1)})
      credit_total = 0
      credits.each do |credit|
        credit_total += credit.value.to_i
      end
      (credit_total <= daily_credit_limit) ? self.accepted! : self.pending!
    end
  end
  
end
