class Transaction < ApplicationRecord
  enum status: { accepted: 0, rejected: 1, pending: 2 }

  after_create :check_wallet_balance_for_debit

  validates :value, :registered_number, :currency_rate, :order, presence: true
  validates :order, uniqueness: true
  validates :value, :currency_rate, numericality: { greater_than: 0 }
  validates :cashback, numericality: { greater_than_or_equal_to: 0 }
  validates :registered_number,
            format: { with: %r{\A(\d{3}\.\d{3}\.\d{3}-\d{2}$)|(^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2})\z} }

  private

  def check_wallet_balance_for_debit
    wallet = ClientWallet.find_by(registered_number:)
    if wallet.balance < value
      pending!
    else
      wallet_transaction(wallet)
    end
  end

  def wallet_transaction(wallet)
    final_value = value - (value * wallet.category.discount / 100)
    if wallet.bonus_balance
      check_bonus_balance(wallet, final_value)
    else
      add_cashback(wallet, final_value)
    end
  end

  def check_bonus_balance(wallet, final_value)
    if wallet.bonus_balance < final_value
      final_value -= wallet.bonus_balance
      wallet.update(bonus_balance: 0)
    else
      wallet.update(bonus_balance: wallet.bonus_balance - final_value)
      final_value = 0
    end
    add_cashback(wallet, final_value)
  end

  def add_cashback(wallet, final_value)
    return wallet.update(balance: wallet.balance - final_value + cashback) if cashback

    wallet.update(balance: wallet.balance - final_value)
  end
end
