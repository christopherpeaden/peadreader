class YoutubeChannel < ActiveRecord::Base
  belongs_to :user
  has_many :youtube_videos

  validates :title, uniqueness: true

  def self.save_channels(current_user, channels)
    channels["items"].each do |channel|
      channel_info = YoutubeClient.get_channel_info(channel["snippet"]["resourceId"]["channelId"])

      current_user.youtube_channels.create(
        title: channel["snippet"]["title"],
        channel_id: channel["snippet"]["resourceId"]["channelId"],
        url: "http://www.youtube.com/channel/#{channel["snippet"]["resourceId"]["channelId"]}",
        image: channel["snippet"]["thumbnails"]["high"]["url"],
        video_count: channel["contentDetails"]["totalItemCount"],
        upload_playlist_id: channel_info["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"]
      )
    end
  end
end
