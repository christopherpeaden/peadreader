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

    playlist_items_response["items"].each { |item| uploads << item }
    uploads
  end
end
