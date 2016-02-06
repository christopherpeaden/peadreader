class AddIndexToYoutubeVideos < ActiveRecord::Migration
  def change
    add_index :youtube_videos, :published_at
    add_index :youtube_videos, :playlist_id
    add_index :youtube_videos, :title
  end
end
