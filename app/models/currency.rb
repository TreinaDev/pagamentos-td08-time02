class Currency < ApplicationRecord
  belongs_to :admin

  enum status: { active: 0, inactive: 5, pending: 9 }
  
  before_create :set_latter_currency_inactive
  after_create :set_pending

  validates :currency_value, :status, presence: true
  validates :currency_value, numericality: { only_float: true, greater_than: 0}

  private

  def set_latter_currency_inactive
    @currency = Currency.last
    if !@currency.nil? && @currency.active?
      @currency.inactive!
    end
  end

  def set_pending
    if Currency.all.count >= 2
      @currencies = Currency.last(2)
      if (@currencies[0].currency_value + @currencies[0].currency_value * 0.1) < @currencies[1].currency_value
        self.pending!
        @currencies[0].active!
      end
    end
  end
end