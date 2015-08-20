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

  def refresh
    @entries = current_user.feeds.entries 
    @entries.each do |entry|
      Entry.create(title: item.title, url: item.url, published: item.published)
    end
    redirect_to root_url
  end


  def dashboard
    @entries = current_user.feeds.entries.paginate(page: params[:page])
  end

  private

    def find_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:title, :url)
    end
      
end
