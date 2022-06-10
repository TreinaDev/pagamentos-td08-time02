class Admin < ApplicationRecord
  before_create :remove_caracteres

  enum :status, { innactive: 0, pending: 1, active: 3, refused: 5 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :registration_number, :email, :password, presence: true
  validates :email, format: { with: /\A[^@\s]+@userubis.com.br\z/ }
  validates :registration_number, format: { with: /\A[0-9]{3}.?[0-9]{3}.?[0-9]{3}-?[0-9]{2}\z/ }
  # validar cpf como unico

  # scopes

  scope :search_pending_admins, -> { where.not(status: :active) }

  private

  def remove_caracteres
    registration_number.replace(registration_number.delete('.').delete('-'))
  end
end
