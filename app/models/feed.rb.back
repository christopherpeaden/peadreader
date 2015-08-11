class Feed < ActiveRecord::Base
  validates :title, presence: true
  validates :url, presence: true

  def self.get_feed_items
    feed_items = []
    all.each do |x|
      feed = Feedjira::Feed.fetch_and_parse(x.url)
      feed.entries.each do |feed|
        feed_items << feed
      end
    end
    feed_items
  end
end
