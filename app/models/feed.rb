class Feed < ActiveRecord::Base
  validates :title, presence: true
  validates :url, presence: true
  belongs_to :user

  def self.get_feed_items_from_current_user(feeds)
    feed_items = []
    feeds.each do |feed|
      parsed_feed = Feedjira::Feed.fetch_and_parse(feed.url)
      parsed_feed.entries.each do |entry|
        feed_items << entry
      end
    end
    feed_items
  end

end
