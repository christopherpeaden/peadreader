class YoutubeClient

  def self.refresh_access_token(current_user)
      url = "https://accounts.google.com/o/oauth2/token"

      options = {
        grant_type: "refresh_token",
        refresh_token: current_user.refresh_token,
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret
      }

      token_info = HTTParty.post(url, body: options, headers: {"Content-Type" => "application/x-www-form-urlencoded"})

      current_user.update(
        access_token: token_info["access_token"],
        access_token_expiration: (Time.now.to_i + token_info["expires_in"].to_i)
      )
  end

  def self.get_subscribed_channels(authenticated_user)

    url = "https://www.googleapis.com/youtube/v3/subscriptions/"

    options = {
      access_token: authenticated_user.access_token,
      mine: "true",
      key: Rails.application.secrets.google_api_key,
      part: "snippet, contentDetails",
      maxResults: "50"
    }

    HTTParty.get(url, query: options)
  end

  def self.get_channel_info(channel_id, options={})

    url = "https://www.googleapis.com/youtube/v3/channels/"

    options = {
      part: "contentDetails, snippet",
      key: Rails.application.secrets.google_api_key,
      id: channel_id
    }

    HTTParty.get(url, query: options)
  end

  def self.get_upload_info_from_channel(playlist_id, options={})

    url = "https://www.googleapis.com/youtube/v3/playlistItems/"

      options = {
        part: "contentDetails, snippet",
        key: Rails.application.secrets.google_api_key,
        playlistId: playlist_id,
        maxResults: "50"
      } if options.empty?
    
    HTTParty.get(url, query: options)
  end

  def self.get_upload_playlist_items(channel, playlist_id, options = {})
    upload_items = []
    upload_info = get_upload_info_from_channel(playlist_id, options)

    loop do
      if previously_synced?(channel)
        item_counter = 0
        upload_info["items"].each do |item|
          break if channel.youtube_videos.find_by(title: upload_info["items"][item_counter]["snippet"]["title"])
          upload_items << item
          item_counter+= 1
        end
        break if channel.youtube_videos.find_by(title: upload_info["items"][item_counter]["snippet"]["title"])
      else
        upload_info["items"].each do |item|
          upload_items << item
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

      upload_info = get_upload_info_from_channel(playlist_id, next_page_options) 
    end
    upload_items
  end

  private
    
    def self.previously_synced?(channel)
      channel.youtube_videos.count > 0 
    end
end
