module FeedsHelper

  def get_feed_items(feed_list)
    feed_items = []
    feed_list.each do |feed|
      parsed_feed = Feedjira::Feed.fetch_and_parse(feed.url)
      parsed_feed.entries.each do |entry|
        feed_items << entry
      end
    end
    feed_items.sort {|x, y| y.published <=> x.published}
  end

end
