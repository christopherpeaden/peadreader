class YoutubeController < ApplicationController

  def sync_subscribed_channels
    @sub_info = YoutubeClient.get_subscribed_channels(current_user)
    YoutubeChannel.save_channels(current_user, @sub_info)

    redirect_to "/subscriptions"
  end

  def refresh
    @categories = current_user.categories

    @sub_info["items"].each do |channel|
      @uploads = YoutubeClient.get_all_uploads_from_channel(channel["snippet"]["resourceId"]["channelId"]
)
      YoutubeVideo.save_videos(@uploads)
    end
    
    redirect_to "/subscriptions"
  end

  def subscriptions 
    @sub_info = YoutubeClient.get_subscribed_channels(current_user)
    @categories = current_user.categories
    @videos = YoutubeVideo.all.sort { |x,y| y.published_at <=> x.published_at }
    @channels = current_user.youtube_channels 
  end

  def refresh_access_token
    @categories = current_user.categories
    @new_token_info = YoutubeClient.refresh_access_token(current_user)
  end
end
