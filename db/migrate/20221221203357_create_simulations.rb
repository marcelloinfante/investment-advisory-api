class CreateSimulations < ActiveRecord::Migration[7.0]
  def up
    create_table :simulations do |t|
      t.string :new_asset_code
      t.string :new_asset_issuer
      t.datetime :new_asset_expiration_date
      t.decimal :new_asset_minimum_rate
      t.decimal :new_asset_maximum_rate
      t.decimal :new_asset_duration
      t.decimal :new_asset_indicative_rate
      t.decimal :new_asset_suggested_rate
      t.datetime :quotation_date
      t.integer :days_in_years
      t.decimal :remaining_years
      t.decimal :average_cdi
      t.decimal :curve_volume
      t.decimal :market_redemption
      t.decimal :market_rate
      t.decimal :new_asset_remaining_years
      t.decimal :agio
      t.decimal :agio_percentage
      t.decimal :percentage_to_recover
      t.decimal :current_final_value
      t.decimal :new_rate_final_value_same_period
      t.decimal :variation_same_period
      t.decimal :new_rate_final_value_new_period
      t.decimal :final_variation
      t.decimal :relative_final_variation
      t.decimal :relative_variation_same_period
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
