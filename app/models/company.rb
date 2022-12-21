class Company < ApplicationRecord
  include Discard::Model

  has_many :users

  validates :name, presence: true

  after_discard do
    users.discard_all
  end

  after_undiscard do
    users.undiscard_all
  end
end
