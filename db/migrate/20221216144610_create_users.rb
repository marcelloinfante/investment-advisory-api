class CreateUsers < ActiveRecord::Migration[7.0]
  def up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :recovery_password_digest
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :users, :email
    add_index :users, :discarded_at
  end

  def down
    drop_table :users
  end
end
