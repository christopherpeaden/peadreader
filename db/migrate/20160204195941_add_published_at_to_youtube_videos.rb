class AddPublishedAtToYoutubeVideos < ActiveRecord::Migration
  def change
    add_column :youtube_videos, :published_at, :datetime
  end
end
