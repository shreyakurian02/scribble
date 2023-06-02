# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false
      t.timestamps
    end
  end
end
