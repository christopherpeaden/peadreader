class YoutubeController < ApplicationController
  def subscriptions 
    @categories = current_user.categories
    url = "https://www.googleapis.com/youtube/v3/subscriptions/"

    options = {
      access_token: current_user.access_token,
      mine: "true",
      key: Rails.application.secrets.google_api_key,
      part: "snippet, contentDetails",
      maxResults: "50"
    }

    @response = HTTParty.get(url, query: options)
  end
end
