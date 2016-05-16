class RemoveCategoryIdFromFeeds < ActiveRecord::Migration
  def change
    remove_column :feeds, :category_id, :integer
  end
end
