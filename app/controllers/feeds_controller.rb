class FeedsController < ApplicationController
  before_action :find_feed, only: [:show, :edit, :update, :destroy]

  def new
    @feed = Feed.new
  end

  def create

    if !params[:feed][:file].nil?
      file = params[:feed][:file].read
      doc = Nokogiri::XML(file)
      doc.xpath("//outline").each_with_index do |outline, index|
        if index != 0
          doc_title = doc.xpath("//outline")[index][:title]
          doc_url   = doc.xpath("//outline")[index][:xmlUrl]
          @feed = current_user.feeds.build(title: doc_title, url: doc_url)
          @feed.save
        end
      end
      flash[:notice] = "Successfully imported OPML file"
      redirect_to feeds_path
    else
      @feed = current_user.feeds.build(feed_params)
      
      @feed.save ? redirect_to(@feed) : render('new')
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
    fetch_feed_items(current_user.feeds)
                    
    redirect_to(:back)
  end


  def dashboard
    !params[:category_id].nil? ? @feeds = current_user.feeds.where(category_id: params[:category_id]) : @feeds = current_user.feeds
    arr = []
    @feeds.each do |feed|
      feed.items.each do |item|
        arr << item
      end
    end
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

end
