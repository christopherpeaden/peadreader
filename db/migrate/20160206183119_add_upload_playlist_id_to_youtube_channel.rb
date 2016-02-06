class AddUploadPlaylistIdToYoutubeChannel < ActiveRecord::Migration
  def change
    add_column :youtube_channels, :upload_playlist_id, :string
  end
end
