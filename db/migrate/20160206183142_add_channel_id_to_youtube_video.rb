class AddChannelIdToYoutubeVideo < ActiveRecord::Migration
  def change
    add_column :youtube_videos, :channel_id, :string
  end
end
