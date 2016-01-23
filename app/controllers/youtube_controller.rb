class YoutubeController < ApplicationController
  def subscriptions 
    @categories = current_user.categories
  end
end
