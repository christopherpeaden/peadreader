class YoutubeController < ApplicationController

  def sync_subscribed_channels
    Thread.new do
      current_user.refresh_access_token if current_user.access_token_expiration - Time.now.to_i < 600 || !current_user.access_token
      subscriptions = current_user.get_subscriptions
      YoutubeChannel.save_channels(subscriptions, current_user.id)
      ActiveRecord::Base.connection.close
    end
    @youtube_channels = current_user.youtube_channels
    flash[:notice] = "Subscriptions updated successfully."
  end

  def refresh_youtube
    Thread.new do
      current_user.youtube_channels.each do |channel|
        @uploads = YoutubeChannel.get_uploads(channel)
        YoutubeVideo.save_videos(channel, @uploads) if !@uploads.empty?
        ActiveRecord::Base.connection.close
      end
    end
    flash[:notice] = "Videos updated successfully."
  end

  def subscriptions 
    @videos = []
    @youtube_channels = current_user.youtube_channels
    @youtube_channels.each do |youtube_channel|
      youtube_channel.youtube_videos.each do |youtube_video|
        @videos << youtube_video
      end
    end
    @videos.sort! { |x,y| y.published_at <=> x.published_at }
    @videos = @videos.paginate(page: params[:page], per_page: 10)
  end

  def check_for_newest_videos
    arr = []
    @youtube_channels = current_user.youtube_channels
    @youtube_channels.each do |youtube_channel|
      youtube_videos_arr = youtube_channel.youtube_videos.where("published_at > ?", params[:after])
      youtube_videos_arr.each { |youtube_video| arr << youtube_video }
    end

    @youtube_videos = arr.sort! { |x,y| y.published_at <=> x.published_at }
    render json: @youtube_videos
  end

  def check_for_new_subscriptions
    arr = []
    youtube_channels_arr = current_user.youtube_channels.where("created_at > ?", params[:after])
    youtube_channels_arr.each do |youtube_channel|
      arr << youtube_channel
    end
    @youtube_channels = arr.sort! { |x,y| y.published_at <=> x.published_at }
    render json: @youtube_channels
  end
end
