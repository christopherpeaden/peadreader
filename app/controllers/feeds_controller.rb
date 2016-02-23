class FeedsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_feed, only: [:show, :edit, :update, :destroy]
  before_action :get_categories, only: [:show, :index, :new, :edit, :dashboard]

  def new
    @feed = Feed.new
  end

  def create
    if file_param_exists?
      opml_doc = setup_file_for_searching
      save_outlines_from_opml(opml_doc, params[:feed][:category_id])
      flash[:notice] = "Successfully imported OPML file"
      redirect_to root_path
    else
      @feed = current_user.feeds.build(feed_params)
      @feed.save ? redirect_to(@feed) : render('new')
    end
  end

  def show
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
    @categories = current_user.categories
=begin
    Thread.new do
      if params[:category_id]
        feed_errors = fetch_feed_items current_user.feeds.where(category_id: params[:category_id]) 
      elsif params[:id]
        feed_errors = fetch_feed_items current_user.feeds.where(id: params[:id])
      else
        feed_errors = fetch_feed_items current_user.feeds
      end
      ActiveRecord::Base.connection.close
    end
    if !feed_errors.empty?
      flash[:error] = "There was a problem with the following feeds: #{feed_errors.join(', ')}" 
    else
      flash[:notice] = "Feeds updated successfully."
    end

    arr = []
    @feeds = current_user.feeds
    @feeds.each {|feed| feed.items.each { |item| arr << item } }
    @items = arr.sort! { |x,y| y.published <=> x.published }
    @items = @items.paginate(page: params[:page])
=end
    arr = []
    @feeds = current_user.feeds
    @feeds.each {|feed| arr << feed.items.first }
    @items = arr.sort! { |x,y| y.published <=> x.published }
    render json: @items.to_json
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

  def test_ajax
    arr = []
    @feeds = current_user.feeds
    @feeds.each {|feed| arr << feed.items.first}
    @items = arr.sort! { |x,y| y.published <=> x.published }
  end

  def test_ajax2
    arr = []
    @feeds = current_user.feeds
    @feeds.each {|feed| arr << feed.items.first}
    @items = arr.sort! { |x,y| y.published <=> x.published }
    render json: @items
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
