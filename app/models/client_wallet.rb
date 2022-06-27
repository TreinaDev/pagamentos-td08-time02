class ClientWallet < ApplicationRecord
  belongs_to :category, optional: true
  before_create :set_default_category

  validates :registered_number, :email, uniqueness: true
  validates :registered_number, :email, :balance, :bonus_balance, presence: true
  validates :balance, :bonus_balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :email,
            format: { with: /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/ }
  validates :registered_number,
            format: { with: %r{\A(\d{3}\.\d{3}\.\d{3}-\d{2}$)|(^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2})\z} }

  private

  def set_default_category
    Category.create(name: 'Padrão', discount: 0) unless Category.any?
    self.category_id = Category.first.id
  end
end
