class Admin < ApplicationRecord
  before_create :remove_caracteres
  has_many :currencies
  enum :status, { innactive: 0, pending: 1, active: 3 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, :registration_number, :email, :password, presence: true
  validates :email, format: { with: /\A[^@\s]+@userubis.com.br\z/ }
  validates :registration_number, format: { with: /\A[0-9]{3}.?[0-9]{3}.?[0-9]{3}-?[0-9]{2}\z/ }

  private

  def remove_caracteres
    registration_number.replace(registration_number.gsub('.', '').gsub('-', ''))
  end
end
