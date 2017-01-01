class Feed < ActiveRecord::Base
  belongs_to :user
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :categories

  validates :title, presence: true, uniqueness: { :scope => :user_id }
  validates :url,   presence: true, uniqueness: { :scope => :user_id }

  def fetch(options = {})
    headers = {
      'If-Modified-Since': options[:last_modified] ||= "",
      'If-None-Match': options[:etag] ||= ""
    }
    HTTParty.get(url, headers: headers)
  end

  def parse(feed_xml)
    Feedjira::Feed.parse(feed_xml)
  end

  def fetch_and_save_new_items
    feed_xml = fetch(last_modified: last_modified, etag: etag)
    if feed_xml.body
      parsed_feed = parse(feed_xml.body)
      update_after_checking_for_new_items(parsed_feed, feed_xml)
    end
  end

  private

    def update_after_checking_for_new_items(parsed_feed, feed_xml)
      NewItemChecker.check(parsed_feed, self)
      reload
      update(
        last_modified: feed_xml.headers['last-modified'] || "",
        etag: feed_xml.headers['etag'] || ""
      )
    end
end
