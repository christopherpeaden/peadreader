class DropYoutubeChannels < ActiveRecord::Migration[5.0]
  def change
    remove_reference :youtube_channels, :user, index: true, foreign_key: true
    drop_table :youtube_channels do |t|
      t.string :title
      t.string :channel_id
      t.string :url
      t.string :video_count
      t.string :upload_playlist_id
      t.string :image

      t.timestamps null: false
    end
  end
end
