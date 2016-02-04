class YoutubeController < ApplicationController
  def subscriptions 
    @categories = current_user.categories
    @sub_info = YoutubeClient.get_subscription_channels(current_user)

    @uploads = YoutubeClient.get_all_uploads_from_channel(@sub_info["items"][0]["snippet"]["resourceId"]["channelId"]
)
  end
end
