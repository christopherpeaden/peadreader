module YoutubeApiClient
  class ChannelsResponse
    attr_reader :total_results, :title, :kind, :description, :published_at, :thumbnail_url,
                :channel_id, :upload_playlist_id
    
    @@api_key = Rails.application.secrets.google_api_key

    def self.api_key=(api_key)
      @@api_key = api_key
    end

    def self.api_key
      @@api_key
    end
 
    def initialize(api_response)
      @kind               = api_response["kind"]
      @total_results      = api_response["pageInfo"]["totalResults"]
      @channel_id         = api_response["items"][0]["id"]
      @title              = api_response["items"][0]["snippet"]["title"]
      @published_at       = api_response["items"][0]["snippet"]["publishedAt"]
      @description        = api_response["items"][0]["snippet"]["description"]
      @thumbnail_url      = api_response["items"][0]["snippet"]["thumbnails"]["high"]["url"]
      @upload_playlist_id = api_response["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"]
    end

    def self.fetch(channel_id, options={})
      url = "https://www.googleapis.com/youtube/v3/channels/"

      options[:part] ||= "contentDetails, snippet"
      options[:key]  ||= api_key
      options[:id]   ||= channel_id

      new(HTTParty.get(url, query: options))
    end
  end
end
