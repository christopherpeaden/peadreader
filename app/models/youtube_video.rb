class YoutubeVideo < ActiveRecord::Base
  belongs_to :youtube_channel

  validates :title, uniqueness: true

  def self.save_videos(channel, videos)
    videos.each do |video|
      new_video = channel.youtube_videos.build(
        title: video["snippet"]["title"],
        url: "http://www.youtube.com/watch?v=#{video["contentDetails"]["videoId"]}",
        image: video["snippet"]["thumbnails"]["high"]["url"],
        playlist_id: video["snippet"]["playlistId"],
        video_id: video["contentDetails"]["videoId"],
        channel_id: video["snippet"]["channelId"],
        published_at: video["snippet"]["publishedAt"]
      )
    end
    new_video.save if new_video.valid?
  end
end
