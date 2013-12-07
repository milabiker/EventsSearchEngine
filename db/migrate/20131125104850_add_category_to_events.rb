class AddCategoryToEvents < ActiveRecord::Migration
  def change
    add_column :events, :category, :Category
  end
end
