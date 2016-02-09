module FeedsHelper

  def fetch_feed_items(feeds)
    feed_errors = []
    feeds.each do |feed|
      begin
        latest_item = feed.items.find_by(published: feed.items.maximum(:published)) 
        parsed_feed = Feedjira::Feed.fetch_and_parse(feed.url)
        store_items(parsed_feed, latest_item, feed)
      rescue
        feed_errors << feed.title
        next 
      end
    end
    feed_errors
  end

  def store_items(parsed_feed, latest_item, feed)
    parsed_feed.entries.each do |item|
      break if latest_item && item.title == latest_item.title
      if item.url =~ /youtube/
        video_code = item.url.split('=')[1]
        feed.items.create(title: item.title, url: item.url, image_thumbnail_url: "http://img.youtube.com/vi/#{video_code}/hqdefault.jpg", published: item.published)
      else
        feed.items.create(title: item.title, url: item.url, published: item.published)
      end
    end
  end

  def file_param_exists? 
    !params[:feed][:file].nil?
  end

  def setup_file_for_searching
    file = params[:feed][:file].read
    Nokogiri::XML(file)
  end

  def save_outlines_from_opml(opml_doc, category_id)
    opml_doc.xpath("/opml/body/outline/outline").each do |outline|
      @feed = current_user.feeds.build(title: outline[:title], url: outline[:xmlUrl], category_id: category_id)
      @feed.save
    end
  end
end
