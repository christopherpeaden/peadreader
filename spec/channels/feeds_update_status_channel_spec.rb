require 'rails_helper'
require 'support/fake_service.rb'

RSpec.describe FeedsUpdateStatusChannel do
  let(:user) { create(:user) }

  describe 'error handling' do
    it "skips feeds that have are not returning xml" do
      first_feed = build(:feed, user: user)
      second_feed = build(:feed, user: user)
      second_feed.url = "www.test-example.com/test/example"
      second_feed.save
      third_feed = create(:feed, user: user)
      
      stub_request(:any, first_feed.url).to_rack(FakeService)
      stub_request(:any, second_feed.url).to_rack(FakeService)
      stub_request(:any, third_feed.url).to_rack(FakeService)
      feeds = [first_feed, second_feed, third_feed]
      feeds_with_errors = []

      feeds.each do |feed|
        begin
          feed.fetch_and_save_new_items
        rescue
          feeds_with_errors << feed.title
        end
      end
        expect(feeds_with_errors.count).to eq 1
    end
  end
end
