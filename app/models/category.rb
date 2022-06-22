class Category < ApplicationRecord
  belongs_to :bonus_conversion, optional: true, dependent: :destroy
  has_many :client_wallets
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { minimum: 3 }

  validates :discount, presence: true
  validates :discount, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end