class CreateClients < ActiveRecord::Migration[7.0]
  def up
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.datetime :discarded_at
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
    add_index :clients, :discarded_at
  end

  def down
    drop_table :clients
  end
end
