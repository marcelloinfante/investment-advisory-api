class CreateSimulations < ActiveRecord::Migration[7.0]
  def up
    create_table :simulations do |t|
      t.string :new_asset_code
      t.string :new_asset_issuer
      t.datetime :new_asset_expiration_date
      t.decimal :new_asset_minimum_rate
      t.decimal :new_asset_maximum_rate
      t.integer :new_asset_duration
      t.decimal :new_asset_indicative_rate
      t.decimal :new_asset_suggested_rate
      t.datetime :quotation_date
      t.integer :days_in_years
      t.decimal :remaining_mounths
      t.decimal :average_cdi
      t.integer :volume_applied
      t.integer :curve_volume
      t.integer :market_redemption
      t.decimal :market_rate
      t.decimal :years_to_expire
      t.integer :agio
      t.decimal :agio_percentage
      t.decimal :percentage_to_recover
      t.decimal :year_to_expire_with_new_rate
      t.decimal :current_final_value
      t.decimal :new_rate_final_value_same_period
      t.decimal :variation_same_period
      t.decimal :final_value_with_new_rate_at_new_period
      t.decimal :final_variation
      t.boolean :is_worth
      t.datetime :discarded_at
      t.belongs_to :asset, foreign_key: true

      t.timestamps
    end
    add_index :simulations, :discarded_at
  end

  def down
    drop_table :simulations
  end
end
