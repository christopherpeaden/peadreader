class YoutubeClient

  def self.refresh_access_token(current_user)
    url = "https://accounts.google.com/o/oauth2/token"

    options = {
      grant_type: "refresh_token",
      refresh_token: current_user.refresh_token,
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret
    }

    HTTParty.post(url, body: options, headers: {"Content-Type" => "application/x-www-form-urlencoded"})
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

  def self.get_upload_info_from_channel(channel_id, options={})

    url = "https://www.googleapis.com/youtube/v3/playlistItems/"

    if options.empty?
      channel_info = get_channel_info(channel_id)

      options = {
        part: "contentDetails, snippet",
        key: Rails.application.secrets.google_api_key,
        playlistId: channel_info["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"],
        maxResults: "50"
      } 
    end
    
    HTTParty.get(url, query: options)
  end

  def self.get_all_uploads_from_channel(channel_id, options = {})
    upload_items = []
    upload_info = get_upload_info_from_channel(channel_id, options)

    existing_video = YoutubeVideo.find_by(title: upload_info["items"][0]["snippet"]["title"])
      
    until existing_video

      upload_info["items"].each do |item|
        upload_items << item
      end

      break if !upload_info["nextPageToken"]

      next_page_options = {
        key: Rails.application.secrets.google_api_key,
        part: "snippet, contentDetails",
        pageToken: upload_info["nextPageToken"],
        playlistId: upload_info["items"][0]["snippet"]["playlistId"],
        maxResults: "50"
      }

      upload_info = get_upload_info_from_channel(channel_id, next_page_options) 
    end
    upload_items
  end
end
