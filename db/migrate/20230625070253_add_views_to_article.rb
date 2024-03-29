# frozen_string_literal: true

class AddViewsToArticle < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :views, :integer, null: false, default: 0
  end
end
