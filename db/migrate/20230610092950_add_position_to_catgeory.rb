# frozen_string_literal: true

class AddPositionToCatgeory < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :position, :integer
  end
end
