class FeedsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_categories
  before_action :find_feed, only: [:show, :edit, :update, :destroy]

  def new
    @feed = Feed.new
  end

  def new_opml_import
  end

  def create_opml_import
    opml_doc = setup_file_for_searching
    save_outlines_from_opml(opml_doc, params[:category_id])
    flash[:notice] = "Successfully imported OPML file"
    redirect_to root_path
  end

  def create
    @feed = current_user.feeds.build(feed_params)
    @feed.save
    @items = []
    @items = @items.paginate(page: params[:page])
  end

  def show
    arr = []
    @feed.items.each { |item| arr << item }
    @items = arr.sort! { |x,y| y.published_at <=> x.published_at }
    @items = @items.paginate(page: params[:page])
  end

  def index
    @feeds = current_user.feeds.order(:title)
  end

  def edit
  end

  def update
    @feed.update(feed_params)
    @items = @feed.items
    @items = @items.paginate(page: params[:page])
  end

  def destroy
    @feed.destroy
    @feeds = current_user.feeds
  end

  def refresh_feeds
    current_user.job_watchers.each {|job_watcher| job_watcher.destroy} if !current_user.job_watchers.empty?
    job_watcher = current_user.job_watchers.create

    Thread.new do
      if params[:category_id]
        feed_errors = fetch_feed_items current_user.feeds.where(category_id: params[:category_id]) 
      elsif params[:id]
        feed_errors = fetch_feed_items current_user.feeds.where(id: params[:id])
      else
        feed_errors = fetch_feed_items current_user.feeds
      end
      job_watcher.update(completed: true)
      ActiveRecord::Base.connection.close
    end
=begin

    if !feed_errors.empty?
      flash[:error] = "There was a problem with the following feeds: #{feed_errors.join(', ')}" 
    else
      flash[:notice] = "Feeds updated successfully."
    end
=end
  end

  def dashboard
    @feeds = current_user.feeds
    arr = []
    !params[:q].nil? ? @feeds.each {|feed| feed.items.each { |item| arr << item if item.title.downcase =~ /#{params[:q].downcase}/ } } : @feeds.each {|feed| feed.items.each { |item| arr << item } }
    @items = arr.sort! { |x,y| y.published_at <=> x.published_at }
    @items = @items.paginate(page: params[:page])
  end

  def check_for_newest_items
    if job_watcher = current_user.job_watchers.first
      arr = []
      @feeds = current_user.feeds

      @feeds.each do |feed|
        items_arr = feed.items.where("published_at > ?", params[:after])
        items_arr.each { |item| arr << item }
      end

      @items = arr.sort! { |x,y| x.published_at <=> y.published_at }
      job_watcher.destroy if job_watcher.completed == true

      render json: @items
    else
      @items = ["completed"]
      render json: @items
    end
  end

  private

    def find_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:title, :url, :category_ids => [], categories_attributes: [:id, :user_id, :title, :_destroy])
    end

    def get_categories
      @categories = current_user.categories.order(:title)
    end
end
