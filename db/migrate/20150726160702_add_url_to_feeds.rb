class AddUrlToFeeds < ActiveRecord::Migration
  def change 
    add_column :feeds, :url, :string
  end
end
