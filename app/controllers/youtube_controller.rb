class YoutubeController < ApplicationController

  def sync_subscribed_channels
    current_user.refresh_access_token if current_user.access_token_expiration - Time.now.to_i < 600 || !current_user.access_token
    subscriptions = current_user.get_subscriptions
    YoutubeChannel.save_channels(subscriptions, current_user.id)
    ActiveRecord::Base.connection.close
    @youtube_channels = current_user.youtube_channels
    flash[:notice] = "Subscriptions updated successfully."
  end

  def refresh_youtube
    current_user.youtube_channels.each do |channel|
      @uploads = YoutubeChannel.get_uploads(channel)
      YoutubeVideo.save_videos(channel, @uploads) if !@uploads.empty?
      ActiveRecord::Base.connection.close
    end
    flash[:notice] = "Videos updated successfully."
  end

  def subscriptions 
    @youtube_channels = current_user.youtube_channels
    @youtube_channels.each {|youtube_channel| @videos = youtube_channel.youtube_videos.order(published_at: :desc).map {|youtube_video| youtube_video}}
    @videos = @videos.paginate(page: params[:page], per_page: 10)
  end
end
