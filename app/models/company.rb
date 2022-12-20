class Company < ApplicationRecord
  include Discard::Model

  has_many :users

  validates :name, presence: true
end
