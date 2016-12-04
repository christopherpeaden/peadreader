require 'rails_helper'

RSpec.describe NewItemChecker do
  let(:user) { create(:user) }
  let(:feed) { create(:feed, user: user) }

  before(:each) do
      stub_request(:any, feed.url).to_return(body: File.open(File.expand_path('./spec/support/sample_xml.rss')))
  end

  describe '#check' do
    it 'parses feed for new items and saves them if valid' do
      feed_xml = feed.fetch(last_modified: feed.last_modified, etag: feed.etag)
      parsed_feed = feed.parse(feed_xml)
      NewItemChecker.check(parsed_feed, feed)
      expect(Item.count).to eq 30
    end

    it "stops checking for new items if 4 items already in database" do
      feed_xml = feed.fetch(last_modified: feed.last_modified, etag: feed.etag)
      parsed_feed = feed.parse(feed_xml)
      entries = parsed_feed.entries.slice(0..2)
      entries << parsed_feed.entries.slice(4)
      NewItemChecker.check(entries, feed)
      expect(Item.count).to eq 4
      NewItemChecker.check(parsed_feed, feed)
      expect(Item.count).to eq 5
    end
  end
end
