class YoutubeController < ApplicationController

  def sync_subscribed_channels
    current_user.refresh_access_token if current_user.access_token_expiration - Time.now.to_i < 600
    @subscriptions = current_user.get_subscriptions
    YoutubeChannel.save_channels(current_user, @subscriptions)
    redirect_to "/subscriptions"
  end

  def refresh_youtube
=begin
    current_user.youtube_channels.each do |channel|
      @uploads = YoutubeChannel.get_uploads(channel, channel.upload_playlist_id)
      YoutubeVideo.save_videos(channel, @uploads)
    end
=end

    arr = []
    @youtube_channels = current_user.youtube_channels
    @youtube_channels.each do |channel|
      channel.youtube_videos.each do |video|
        arr << video
      end
    end
    @videos = arr.sort! { |x,y| y.published_at <=> x.published_at }
    @videos = @videos.paginate(page: params[:page], per_page: 10)
  end

  def subscriptions 
    @youtube_channels = current_user.youtube_channels
    @videos = YoutubeVideo.all.sort { |x,y| y.published_at <=> x.published_at }
    @videos = @videos.paginate(page: params[:page], per_page: 10)
  end
end
