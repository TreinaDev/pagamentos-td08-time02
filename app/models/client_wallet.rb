class ClientWallet < ApplicationRecord
  belongs_to :category, optional: true

  validates :registered_number, :email, :balance, :bonus_balance, presence: true
  validates :balance, :bonus_balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :email, format: { with: /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/ }
  validates :registered_number, format: { with: /\A(\d{3}\.\d{3}\.\d{3}\-\d{2}$)|(^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2})\z/ }

end
