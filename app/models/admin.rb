class Admin < ApplicationRecord
  before_create :remove_caracteres
  has_many :currencies
  enum :status, { inactive: 0, pending: 1, active: 3, refused: 5 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :registration_number, presence: true
  validates :email, format: { with: /\A[^@\s]+@userubis.com.br\z/ }
  validates :registration_number, format: { with: /\A[0-9]{3}.?[0-9]{3}.?[0-9]{3}-?[0-9]{2}\z/ }
  validates :registration_number, uniqueness: true
  # validar cpf como unico

  # scopes

  scope :search_pending_admins, -> { where.not(status: %i[active refused]) }

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    inactive? ? super : :inactive
  end

  private

  def remove_caracteres
    registration_number.replace(registration_number.delete('.').delete('-'))
  end
end
