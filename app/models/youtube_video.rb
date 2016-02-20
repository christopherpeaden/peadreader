class YoutubeVideo < ActiveRecord::Base
  belongs_to :youtube_channel

  validates :title, uniqueness: true

  def self.save_videos(channel, videos)
    videos.each do |video|
      new_video = YoutubeVideo.new(
        title: video["snippet"]["title"],
        url: "http://www.youtube.com/watch?v=#{video["contentDetails"]["videoId"]}",
        image: video["snippet"]["thumbnails"]["high"]["url"],
        playlist_id: video["snippet"]["playlistId"],
        video_id: video["contentDetails"]["videoId"],
        channel_id: video["snippet"]["channelId"],
        published_at: video["snippet"]["publishedAt"],
        youtube_channel_id: channel.id
      )

      new_video.save if new_video.valid?
    end
  end
end
