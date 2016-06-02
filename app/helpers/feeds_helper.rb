module FeedsHelper

  def fetch_feed_items(feeds)
    feed_errors = []
    feeds.each do |feed|
      begin
        parsed_feed = Feedjira::Feed.fetch_and_parse(feed.url)
        store_items(parsed_feed, feed)
      rescue
        feed_errors << feed.title
        next 
      end
    end
    feed_errors
  end

  def store_items(parsed_feed, feed)
    parsed_feed.entries.each do |item|
      if item.url =~ /youtube/
        video_code = item.url.split('=')[1]
        new_item = feed.items.build(title: item.title,
                                    url: item.url,
                                    image_thumbnail_url: "http://img.youtube.com/vi/#{video_code}/hqdefault.jpg",
                                    published_at: item.published, feed_title: feed.title, user_id: current_user.id)
        new_item.save if new_item.valid?
      else
        new_item = feed.items.build(title: item.title,
                                    url: item.url,
                                    published_at: item.published,
                                    feed_title: feed.title, user_id: current_user.id)
        new_item.save if new_item.valid?
      end
    end
  end

  def file_param_exists? 
    !params[:feed][:file].nil?
  end

  def setup_file_for_searching
    file = params[:file].read
    Nokogiri::XML(file)
  end

  def save_outlines_from_opml(opml_doc, category_id)
    opml_doc.xpath("/opml/body/outline/outline").each do |outline|
      @feed = current_user.feeds.build(title: outline[:title], url: outline[:xmlUrl], category_ids: params["<option value="])
      @feed.save
    end
  end
end
