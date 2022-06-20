class Transaction < ApplicationRecord
  enum status: { accepted: 0, rejected: 1 }
  enum transaction_type: { debit: 0, credit: 1 }

  validates :value, :registered_number, :currency_rate, presence: true
  validates :value, :currency_rate, numericality: { greater_than: 0 }
  validates :registered_number,
            format: { with: %r{\A(\d{3}\.\d{3}\.\d{3}-\d{2}$)|(^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2})\z} }
end
