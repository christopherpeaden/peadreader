module FeedsHelper

  def fetch_feed_items(feeds)
    feed_errors = []
    threads = []
    feeds.each do |feed|
      threads << Thread.new(feed) do |thread_feed|
        begin
          #latest_item = feed.items.find_by(published_at: feed.items.maximum(:published_at)) 
          parsed_feed = Feedjira::Feed.fetch_and_parse(thread_feed.url)
          store_items(parsed_feed, thread_feed)
        rescue
          feed_errors << thread_feed.title
          next 
        end
      end
    end
    threads.each { |thread| thread.join}
    feed_errors
  end

  def store_items(parsed_feed, feed)
    parsed_feed.entries.each do |item|
      # break if latest_item && item.title == latest_item.title
      if item.url =~ /youtube/
        video_code = item.url.split('=')[1]
        new_item = feed.items.build(title: item.title, url: item.url, image_thumbnail_url: "http://img.youtube.com/vi/#{video_code}/hqdefault.jpg", published_at: item.published, feed_title: feed.title)
        new_item.save if new_item.valid?
      else
        new_item = feed.items.build(title: item.title, url: item.url, published_at: item.published, feed_title: feed.title)
        new_item.save if new_item.valid?
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
