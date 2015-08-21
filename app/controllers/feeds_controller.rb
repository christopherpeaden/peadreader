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
    @feeds = current_user.feeds
    @feeds.each do |feed|
      Entry.create(title: feed.entry.title, url: feed.entry.url, published: feed.entry.published)
    end
    redirect_to root_url
  end


  def dashboard
    @feeds = current_user.feeds
    arr = []
    @feeds.each do |feed|
      @entries = feed.entries
      @entries.each do |entry|
        arr << entry
      end
    end
    @entries = arr
    @entries = @entries.paginate(page: params[:page])
  end

  private

    def find_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:title, :url)
    end
      
end
