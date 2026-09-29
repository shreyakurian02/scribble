# frozen_string_literal: true

class AddAuthToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :password_digest, :string
    add_column :users, :authentication_token, :string
    execute "UPDATE users SET authentication_token = encode(gen_random_bytes(18), 'hex') " \
            "WHERE authentication_token IS NULL"
    add_index :users, :authentication_token, unique: true
  end

  def down
    remove_index :users, :authentication_token
    remove_column :users, :authentication_token
    remove_column :users, :password_digest
  end
end
