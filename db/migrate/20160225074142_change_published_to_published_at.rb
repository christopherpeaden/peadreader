class ChangePublishedToPublishedAt < ActiveRecord::Migration
  def change
    rename_column :items, :published, :published_at
  end
end
