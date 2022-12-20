class CreateCompanies < ActiveRecord::Migration[7.0]
  def up
    create_table :companies do |t|
      t.string :name
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :companies, :discarded_at
  end

  def down
    drop_table :companies
  end
end
