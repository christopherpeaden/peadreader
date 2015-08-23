module FeedsHelper

  def fetch_feed_items(feed_list)
    feed_list.each do |feed|
      feed_items = []
      latest_item = feed.items.find_by(published: feed.items.maximum(:published)) 
      parsed_feed = Feedjira::Feed.fetch_and_parse(feed.url)
      parsed_feed.entries.each do |entry|
        break if latest_item && entry.title == latest_item.title
        feed_items << entry
      end
      feed_items.each { |item| Item.create(title: item.title, url: item.url, published: item.published, feed_id: feed.id) }
    end
  end

end
