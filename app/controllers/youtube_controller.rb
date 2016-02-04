class YoutubeController < ApplicationController

  def refresh
    @categories = current_user.categories
    @sub_info = YoutubeClient.get_subscription_channels(current_user)

    @uploads = YoutubeClient.get_all_uploads_from_channel(@sub_info["items"][0]["snippet"]["resourceId"]["channelId"]
)
    YoutubeVideo.save_videos(@uploads)
    redirect_to "/subscriptions"
  end

  def subscriptions 
    @categories = current_user.categories
    @videos = YoutubeVideo.all
  end
end
