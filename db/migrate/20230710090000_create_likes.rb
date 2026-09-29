# frozen_string_literal: true

class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes, id: :uuid do |t|
      t.references :article, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :visitor_token, null: false
      t.index [:article_id, :visitor_token], unique: true
      t.timestamps
    end

    add_column :articles, :likes_count, :integer, default: 0, null: false
  end
end
