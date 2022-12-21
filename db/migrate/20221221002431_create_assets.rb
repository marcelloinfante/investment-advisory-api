class CreateAssets < ActiveRecord::Migration[7.0]
  def up
    create_table :assets do |t|
      t.string :code
      t.string :issuer
      t.string :rate_index
      t.decimal :entrance_rate
      t.integer :quantity
      t.datetime :application_date
      t.datetime :expiration_date
      t.belongs_to :client, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :assets
  end
end
