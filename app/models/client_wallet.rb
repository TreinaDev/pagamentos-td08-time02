class ClientWallet < ApplicationRecord
  belongs_to :category, optional: true
  has_many :credits
  after_find :verify_bonus_balance
  
  validates :registered_number, :email, uniqueness: true
  validates :registered_number, :email, :balance, :bonus_balance, presence: true
  validates :balance, :bonus_balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :email,
            format: { with: /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/ }
  validates :registered_number,
            format: { with: %r{\A(\d{3}\.\d{3}\.\d{3}-\d{2}$)|(^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2})\z} }


  def verify_bonus_balance
    if !self.category.bonus_conversion.nil?
      credits = Credit.where(client_wallet_id: id)
      credits.each do |credit|
        credit_deadline = (credit.created_at.to_date + category.bonus_conversion.deadline.days)
        if (credit_deadline < Time.zone.now.to_date) && (credit.created_at.to_date > credit.bonus_conversion.initial_date)
          final_balance = self.bonus_balance - credit.bonus_balance
          if final_balance.negative?
            self.bonus_balance = 0
          else
            self.bonus_balance -= credit.bonus_balance
          end
        end
      end
    end
  end
end
