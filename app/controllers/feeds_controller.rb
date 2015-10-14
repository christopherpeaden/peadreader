class FeedsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_feed, only: [:show, :edit, :update, :destroy]
  before_action :get_categories, only: [:show, :new, :edit, :dashboard]

  def new
    @feed = Feed.new
  end

  def create
    if file_param_exists?
      opml_doc = setup_file_for_searching
      save_outlines_from_opml(opml_doc)
      flash[:notice] = "Successfully imported OPML file"
      redirect_to root_path
    else
      @feed = current_user.feeds.build(feed_params)
      @feed.save ? redirect_to(@feed) : render('new')
    end
  end

  def show
    @categories = current_user.categories
    arr = []
    @feed.items.each { |item| arr << item }
    @items = arr.sort! { |x,y| y.published <=> x.published }
    @items = @items.paginate(page: params[:page])
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
    if params[:category_id]
      fetch_feed_items current_user.feeds.where(category_id: params[:category_id]) 
    elsif params[:id]
      fetch_feed_items current_user.feeds.where(id: params[:id])
    else
      fetch_feed_items current_user.feeds
    end
    redirect_to(:back)
  end


  def dashboard
    @categories = current_user.categories
    session[:referer] = request.original_url
    !params[:category_id].nil? ? @feeds = current_user.feeds.where(category_id: params[:category_id]) : @feeds = current_user.feeds
    arr = []
    !params[:q].nil? ? @feeds.each {|feed| feed.items.each { |item| arr << item if item.title.downcase =~ /#{params[:q].downcase}/ } } : @feeds.each {|feed| feed.items.each { |item| arr << item } }
    @items = arr.sort! { |x,y| y.published <=> x.published }
    @items = @items.paginate(page: params[:page])
  end

  private

    def find_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:title, :url, :category_id)
    end

    def get_categories
      @categories = current_user.categories
    end
end
