class YoutubeChannel < ActiveRecord::Base
  belongs_to :user
  has_many :youtube_videos, dependent: :destroy

  validates :title, uniqueness: true

  def self.save_channels(channels, user_id)
    channels["items"].each do |channel|
      channels_response = YoutubeApiClient::ChannelsResponse.fetch(channel["snippet"]["resourceId"]["channelId"])
      
      new_channel = YoutubeChannel.new(
        title: channel["snippet"]["title"],
        channel_id: channel["snippet"]["resourceId"]["channelId"],
        url: "http://www.youtube.com/channel/#{channel["snippet"]["resourceId"]["channelId"]}",
        image: channel["snippet"]["thumbnails"]["high"]["url"],
        video_count: channel["contentDetails"]["totalItemCount"],
        upload_playlist_id: channels_response.upload_playlist_id,
        user_id: user_id.to_i
      )

      new_channel.save if new_channel.valid?
    end
  end

  def self.get_uploads(channel, options={})
    uploads = []
    playlist_items_response = YoutubeApiClient::PlaylistItemsResponse.fetch(channel.upload_playlist_id, options)

    loop do
      if previously_synced?(channel)
        item_counter = 0
        playlist_items_response["items"].each do |item|
          break if channel.youtube_videos.find_by(title: playlist_items_response["items"][item_counter]["snippet"]["title"])
          uploads << item
          item_counter+= 1
        end
        break if channel.youtube_videos.find_by(title: playlist_items_response["items"][item_counter]["snippet"]["title"])
      else
        playlist_items_response["items"].each do |item|
          uploads << item
        end
      end

      break if !playlist_items_response["nextPageToken"]

      playlist_items_response = YoutubeApiClient::PlaylistItemsResponse.fetch(channel.upload_playlist_id, pageToken: playlist_items_response["nextPageToken"])
    end
    uploads
  end

  private
    
    def self.previously_synced?(channel)
      channel.youtube_videos.count > 0 
    end
end
