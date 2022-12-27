class Asset < ApplicationRecord
  include Discard::Model

  has_many :simulations
  belongs_to :client

  validates :code, presence: true
  validates :issuer, presence: true
  validates :rate_index, presence: true
  validates :entrance_rate, presence: true
  validates :quantity, presence: true
  validates :volume_applied, presence: true
  validates :application_date, presence: true
  validates :expiration_date, presence: true

  after_discard do
    simulations.discard_all
  end

  after_undiscard do
    simulations.undiscard_all
  end
end
