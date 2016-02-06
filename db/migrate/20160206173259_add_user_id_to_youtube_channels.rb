class AddUserIdToYoutubeChannels < ActiveRecord::Migration
  def change
    add_reference :youtube_channels, :user, index: true, foreign_key: true
  end
end
