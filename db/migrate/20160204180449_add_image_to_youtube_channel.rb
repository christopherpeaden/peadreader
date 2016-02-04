class AddImageToYoutubeChannel < ActiveRecord::Migration
  def change
    add_column :youtube_channels, :image, :string
  end
end
