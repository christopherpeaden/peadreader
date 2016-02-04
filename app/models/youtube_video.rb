class YoutubeVideo < ActiveRecord::Base
  belongs_to :youtube_channel

  def self.save_videos(videos)
    
    videos.each do |video|
      existing_video = YoutubeVideo.find_by(title: video["snippet"]["title"])

      break if existing_video 

      YoutubeVideo.create(
        title: video["snippet"]["title"],
        url: "http://www.youtube.com/watch?v=#{video["contentDetails"]["videoId"]}",
        image: video["snippet"]["thumbnails"]["high"]["url"],
        playlist_id: "",
        video_id: "",
        youtube_channel_id: "",
        published_at: video["snippet"]["publishedAt"]
      )
    end
  end
end
