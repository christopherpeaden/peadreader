class AddFeedTitleToItems < ActiveRecord::Migration
  def change
    add_column :items, :feed_title, :string
  end
end
