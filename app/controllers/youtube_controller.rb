class YoutubeController < ApplicationController

  def sync_subscribed_channels
    YoutubeClient.refresh_access_token(current_user) if current_user.access_token_expiration - Time.now.to_i < 600
    @subscriptions = YoutubeClient.get_subscribed_channels(current_user)

    YoutubeChannel.save_channels(current_user, @subscriptions)
    redirect_to "/subscriptions"
  end

  def refresh
    @categories = current_user.categories

    current_user.youtube_channels.each do |channel|
      @uploads = YoutubeClient.get_upload_playlist_items(channel, channel.upload_playlist_id)
      YoutubeVideo.save_videos(channel, @uploads)
    end
    
    redirect_to "/subscriptions"
  end

  def subscriptions 
    @activities = YoutubeClient.get_activities(current_user)
    @youtube_channels = current_user.youtube_channels
    @videos = YoutubeVideo.all.sort { |x,y| y.published_at <=> x.published_at }
    @videos = @videos.paginate(page: params[:page], per_page: 10)
  end
end
