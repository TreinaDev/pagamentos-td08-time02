class Currency < ApplicationRecord
  belongs_to :admin

  enum status: { active: 0, inactive: 5, pending: 9 }
  
  after_create :set_pending

  validates :currency_value, :status, presence: true
  validates :currency_value, numericality: { only_float: true, greater_than: 0 }

  private

  def set_pending
    if Currency.active.count >= 2
      @currencies = Currency.active.last(2)
      if (@currencies[0].currency_value + @currencies[0].currency_value * 0.1) < @currencies[1].currency_value
        self.pending!
      end
    end
  end

  def self.set_inactive_if_3_days_ago
    @currencies = Currency.active
    @currencies.each do |currency|
      currency.inactive! if !currency.nil? && currency.created_at.to_date < 3.days.ago
    end
  end
end
