class YoutubeChannelsController < ApplicationController
  layout "youtube"

  def show
    @youtube_channels = current_user.youtube_channels
    @youtube_channel = YoutubeChannel.find(params[:id])
  end
end
