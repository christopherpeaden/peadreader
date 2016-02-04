class YoutubeChannel < ActiveRecord::Base
  has_many :youtube_videos

  def save_channels(channels)
    channels.each do |channel|
      YoutubeChannel.create(
        title: channel["snippet"]["title"],
        channel_id, "",
        url: "",
        image: channel["snippet"]["thumbnails"]["high"]["url"],
        video_count: channel["contentDetails"]["totalItemCount"],
        image: ""
      )
    end
  end
end
