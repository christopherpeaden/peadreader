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
    opml_doc = Nokogiri::XML(params[:file])
    save_outlines_from_opml(opml_doc, params[:category_id])
    flash[:notice] = "Successfully imported OPML file"
    redirect_to root_path
  end

  def create
    @feed = current_user.feeds.build(feed_params)

    if @feed.save
      redirect_to @feed
    else
      flash.now[:danger] = "There was a problem saving your feed."
      render 'new'
    end
  end

  def show
    @items = @feed.items.order(published_at: :desc)
    @items = @items.paginate(page: params[:page])
  end

  def index
    @feeds = current_user.feeds.order(:title)
  end

  def edit
  end

  def update
    if @feed.update(feed_params)
      @items = @feed.items.order(published_at: :desc)
      @items = @items.paginate(page: params[:page])
      redirect_to @feed
    else
      flash.now[:danger] = "There was a problem updating this feed."
      render 'edit'
    end
  end

  def destroy
    if @feed.destroy
      flash[:success] = "Feed deleted successfully."
      redirect_to feeds_path
    else
      flash[:danger] = "There was a problem deleteing this feed."
      render @feed
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
