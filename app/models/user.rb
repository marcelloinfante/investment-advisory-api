class User < ApplicationRecord
  include Discard::Model

  has_secure_password
  has_secure_password :recovery_password, validations: false

  validates :name, presence: true

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
