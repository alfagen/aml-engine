class AddUser < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt
      t.string :reset_password_token
      t.datetime :reset_password_token_expires_at
      t.datetime :reset_password_email_sent_at
      t.integer :access_count_to_reset_password_page
      t.string :time_zone_name
      t.string :locale
      t.string :name
      t.timestamps
    end

    add_reference :aml_operators, :user, foreign_key: true
    add_index :users, :email, unique: true
  end

  def down
    drop_table :users
  end
end
