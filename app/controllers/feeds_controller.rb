class FeedsController < ApplicationController
  before_action :find_feed, only: [:show, :edit, :update, :destroy]

  def new
    @feed = Feed.new
  end

  def create
    @feed = current_user.feeds.build(feed_params)

    if @feed.save
      redirect_to @feed
    else
      render 'new'
    end
  end

  def show
  end

  def index
    @feeds = current_user.feeds
  end

  def edit
  end

  def update
    if @feed.update(feed_params)
      redirect_to @feed
    else
      render 'edit'
    end
  end

  def destroy
    @feed.destroy
    redirect_to root_path
  end

  def feed_items 
    @feed_items = Feed.get_feed_items_from_current_user(current_user.feeds)
  end

  private

    def find_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:title, :url)
    end
      
end
