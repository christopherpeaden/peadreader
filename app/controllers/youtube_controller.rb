class YoutubeController < ApplicationController

  def sync_subscribed_channels
    current_user.refresh_access_token if current_user.access_token_expiration - Time.now.to_i < 600
    subscriptions = current_user.get_subscriptions
    YoutubeChannel.save_channels(subscriptions, current_user.id)
    @youtube_channels = current_user.youtube_channels
  end

  def refresh_youtube
    current_user.youtube_channels.each do |channel|
      @uploads = YoutubeChannel.get_uploads(channel)
      YoutubeVideo.save_videos(channel, @uploads) if !@uploads.empty?
    end

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
