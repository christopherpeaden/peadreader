class FeedsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_feed, only: [:show, :edit, :update, :destroy]
  before_action :get_categories, only: [:show, :index, :new, :edit, :update, :destroy, :dashboard]
  # after_action :set_access_control_headers

  def new
    @feed = Feed.new
  end

  def create
    @categories = current_user.categories
    if file_param_exists?
      opml_doc = setup_file_for_searching
      save_outlines_from_opml(opml_doc, params[:feed][:category_id])
      flash[:notice] = "Successfully imported OPML file"
      redirect_to root_path
    else
      @feed = current_user.feeds.build(feed_params)
      @feed.save
      @items = []
      @items = @items.paginate(page: params[:page])
      # render("feeds/#{params[:id]}")
      # else
      # render('new') if !@feed.save
      #end
    end
  end

  def show
    arr = []
    @feed.items.each { |item| arr << item }
    @items = arr.sort! { |x,y| y.published_at <=> x.published_at }
    @items = @items.paginate(page: params[:page])
  end

  def index
    @feeds = current_user.feeds
  end

  def edit
  end

  def update
    @feed.update(feed_params)
    @items = @feed.items
    @items = @items.paginate(page: params[:page])
=begin
    if
      redirect_to @feed
    else
      render 'edit'
    end
=end
  end

  def destroy
    @feed.destroy
    @feeds = current_user.feeds
  end

  def refresh_feeds
    @categories = current_user.categories
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
    @categories = current_user.categories
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
      params.require(:feed).permit(:title, :url, :category_ids => [])
    end

    def get_categories
      @categories = current_user.categories
    end

    def set_access_control_headers 
      headers['Access-Control-Allow-Origin'] = "*"
      headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
    end
end
