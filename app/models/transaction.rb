class Transaction < ApplicationRecord
  enum status: { accepted: 0, rejected: 1, pending: 2 }
  enum transaction_type: { debit: 0, credit: 1 }

  after_create :check_wallet_balance_for_debit

  validates :value, :registered_number, :currency_rate, presence: true
  validates :value, :currency_rate, numericality: { greater_than: 0 }
  validates :registered_number,
            format: { with: %r{\A(\d{3}\.\d{3}\.\d{3}-\d{2}$)|(^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2})\z} }

  private

  def check_wallet_balance_for_debit
    wallet = ClientWallet.find_by(registered_number:)
    if wallet.balance < value
      pending!
    elsif value.positive?
      wallet_transaction(wallet)
    end
  end

  def wallet_transaction(wallet)
    total_discount = value - (value * wallet.category.discount / 100)
    if cashback
      wallet.update(balance: wallet.balance - total_discount + cashback)
    else
      wallet.update(balance: wallet.balance - total_discount)
    end
  end
end
