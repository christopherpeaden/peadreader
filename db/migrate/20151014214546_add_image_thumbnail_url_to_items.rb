class AddImageThumbnailUrlToItems < ActiveRecord::Migration
  def change
    add_column :items, :image_thumbnail_url, :string
  end
end
