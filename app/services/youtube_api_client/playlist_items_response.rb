module YoutubeApiClient
  class PlaylistItemsResponse
    attr_reader :kind, :total_results

    def initialize(api_response)
      @kind          = api_response["kind"]
      @total_results = api_response["pageInfo"]["totalResults"]
    end

    def self.fetch(playlist_id, options={})
      url = "https://www.googleapis.com/youtube/v3/playlistItems/"

      options[:part]       ||= "contentDetails, snippet"
      options[:key]        ||=  Rails.application.secrets.google_api_key
      options[:playlistId] ||= playlist_id
      options[:maxResults] ||= "50"
    
      HTTParty.get(url, query: options)
    end
  end
end
