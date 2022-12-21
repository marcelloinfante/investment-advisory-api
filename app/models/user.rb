class User < ApplicationRecord
  include Discard::Model

  has_secure_password
  has_secure_password :recovery_password, validations: false

  has_many :clients
  belongs_to :company, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_discard do
    clients.discard_all
  end

  after_undiscard do
    clients.undiscard_all
  end
end
