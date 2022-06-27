class CreditLimit < ApplicationRecord
  validates :max_limit, presence: true
  validates :max_limit, numericality: { greater_than_or_equal_to: 0 }
end
