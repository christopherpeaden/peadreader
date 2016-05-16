class AddFavoriteAndSaveForLaterToItems < ActiveRecord::Migration
  def change
    add_column :items, :favorite, :boolean, default: false
    add_column :items, :saved_for_later, :boolean, default: false
    add_index :items, :favorite
    add_index :items, :saved_for_later
  end
end
