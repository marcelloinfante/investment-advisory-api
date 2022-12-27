class CreateAssets < ActiveRecord::Migration[7.0]
  def up
    create_table :assets do |t|
      t.string :code
      t.string :issuer
      t.string :rate_index
      t.decimal :entrance_rate
      t.integer :quantity
      t.decimal :volume_applied
      t.datetime :application_date
      t.datetime :expiration_date
      t.datetime :discarded_at
      t.belongs_to :client, foreign_key: true

      t.timestamps
    end
    add_index :assets, :discarded_at
  end

  def down
    drop_table :assets
  end
end
