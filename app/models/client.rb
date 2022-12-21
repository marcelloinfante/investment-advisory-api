class Client < ApplicationRecord
  include Discard::Model

  has_many :assets
  belongs_to :user

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_discard do
    assets.discard_all
  end

  after_undiscard do
    assets.undiscard_all
  end
end
