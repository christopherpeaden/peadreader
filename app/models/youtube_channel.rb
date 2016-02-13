class YoutubeChannel < ActiveRecord::Base
  belongs_to :user
  has_many :youtube_videos

  validates :title, uniqueness: true

  def self.save_channels(current_user, channels)
    channels["items"].each do |channel|
      channel_info = get_info(channel["snippet"]["resourceId"]["channelId"])

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

  def self.get_info(channel_id, options={})

    url = "https://www.googleapis.com/youtube/v3/channels/"

    options = {
      part: "contentDetails, snippet",
      key: Rails.application.secrets.google_api_key,
      id: channel_id
    }

    HTTParty.get(url, query: options)
  end

  def self.get_upload_info(playlist_id, options={})

    url = "https://www.googleapis.com/youtube/v3/playlistItems/"

      options = {
        part: "contentDetails, snippet",
        key: Rails.application.secrets.google_api_key,
        playlistId: playlist_id,
        maxResults: "50"
      } if options.empty?
    
    HTTParty.get(url, query: options)
  end

  def self.get_uploads(channel, playlist_id, options = {})
    uploads = []
    upload_info = get_upload_info(playlist_id, options)

    loop do
      if previously_synced?(channel)
        item_counter = 0
        upload_info["items"].each do |item|
          break if channel.youtube_videos.find_by(title: upload_info["items"][item_counter]["snippet"]["title"])
          uploads << item
          item_counter+= 1
        end
        break if channel.youtube_videos.find_by(title: upload_info["items"][item_counter]["snippet"]["title"])
      else
        upload_info["items"].each do |item|
          uploads << item
        end
      end


      break if !upload_info["nextPageToken"]

      next_page_options = {
        key: Rails.application.secrets.google_api_key,
        part: "snippet, contentDetails",
        pageToken: upload_info["nextPageToken"],
        playlistId: playlist_id,
        maxResults: "50"
      }

      upload_info = get_upload_info(playlist_id, next_page_options) 
    end
    uploads
  end

  private
    
    def self.previously_synced?(channel)
      channel.youtube_videos.count > 0 
    end
end
