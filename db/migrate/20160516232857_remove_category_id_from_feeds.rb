class RemoveCategoryIdFromFeeds < ActiveRecord::Migration
  def change
    remove_reference :feeds, :category, index: true, foreign_key: true
  end
end
