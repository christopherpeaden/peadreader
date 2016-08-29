class AddLastModifiedAndEtagToFeeds < ActiveRecord::Migration[5.0]
  def change
    add_column :feeds, :last_modified, :string, default: ""
    add_column :feeds, :etag, :string, default: ""
  end
end
