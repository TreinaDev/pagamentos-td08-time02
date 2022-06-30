class Credit < ApplicationRecord
  belongs_to :bonus_conversion, optional: true
  belongs_to :client_wallet
  before_create :set_bonus_conversion
  after_create :check_daily_credit_limit
  after_create :update_client_wallet
  validates :value, presence: true
  validates :value, numericality: { greater_than: 0 }
  enum status: { pending: 2, accepted: 0, refused: 4 }

  def update_client_wallet
    add_rubis_to_wallet if accepted?
    client_wallet.save
  end

  private

  def daily_credit_limit
    CreditLimit.last.max_limit if CreditLimit.all.any?
  end

  def set_bonus_conversion
    self.bonus_balance += (rubi_value * client_wallet.category.bonus_conversion.percentage * 0.01).to_i unless
                                                                  client_wallet.category.bonus_conversion.nil?
  end

  def rubi_value
    (value / Currency.active.last.currency_value * 100.0).to_i
  end

  def check_credits
    credits = Credit.where(client_wallet:).where('created_at >= :start_date AND created_at <= :end_date',
                                                 { start_date: Time.zone.today.midnight,
                                                   end_date: (Time.zone.tomorrow.midnight - 1) })
    credit_total = 0
    credits.each do |credit|
      credit_total += credit.value.to_i
    end
    credit_total <= daily_credit_limit ? accepted! : pending!
  end

  def check_daily_credit_limit
    check_credits unless daily_credit_limit.nil?
  end

  def add_rubis_to_wallet
    if client_wallet.category.bonus_conversion.nil?
      client_wallet.balance += ((value / Currency.active.last.currency_value) * 100).to_i
    else
      client_wallet.balance += rubi_value
      client_wallet.bonus_balance += bonus_balance if DateTime.now <= client_wallet.category.bonus_conversion.final_date
    end
  end
end
