class BonusConversion < ApplicationRecord
  belongs_to :admin
  validates :initial_date, :final_date, :percentage, :deadline, presence: true
  validates :final_date, comparison: { greater_than: :initial_date }
  #validates :initial_date, comparison: { greater_than_or_equal_to: Time.zone.today }
  validates :deadline, numericality: { greater_than: 0 }
end
