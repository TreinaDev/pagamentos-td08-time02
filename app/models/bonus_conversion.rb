class BonusConversion < ApplicationRecord
  belongs_to :admin
  validates :initial_date, :final_date, :percentage, :deadline, presence: true
  validates :final_date, comparison: { greater_than: :initial_date }
  validates :deadline, numericality: { greater_than: 0 }

  def format_percentage
    "#{percentage}%"
  end
end
