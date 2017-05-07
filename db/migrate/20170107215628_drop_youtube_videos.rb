class DropYoutubeVideos < ActiveRecord::Migration[5.0]
  def change
    remove_index   :youtube_videos, :published_at
    remove_index   :youtube_videos, :playlist_id
    remove_index   :youtube_videos, :title
    drop_table     :youtube_videos do |t|
      t.string     :title
      t.string     :url
      t.string     :playlist_id
      t.string     :video_id
      t.string     :image
      t.string     :channel_id
      t.datetime   :published_at
      t.references :youtube_channel, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
