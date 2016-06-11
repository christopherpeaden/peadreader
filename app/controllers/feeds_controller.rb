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
    @items = @feed.items
    @items = @items.order(published_at: :desc)
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

  def dashboard
    !params[:q].nil? ? @items = current_user.items.where("item.title ~* /#{params[:q].downcase}/") : @items = current_user.items
    @items = @items.order(:published_at => :desc)
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
