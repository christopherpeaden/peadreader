class RemoveFavoriteAndSaveForLaterFromItems < ActiveRecord::Migration[5.0]
  def change
    remove_index :items, column: :favorite
    remove_index :items, column: :saved_for_later
    remove_column :items, :favorite, :boolean, default: false
    remove_column :items, :saved_for_later, :boolean, default: false
  end
end
