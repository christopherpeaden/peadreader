require 'rails_helper'
require 'support/fake_service.rb'

RSpec.describe Feed do
  let(:user) { create(:user) }
  subject { build(:feed, user: user) } 
  let(:feed) { subject }
  let(:user_2) { create(:user, email: "snorlax123@example.com", password: "12345678", password_confirmation: "12345678") }

  describe "messages" do
    it {should respond_to(:id) }
    it {should respond_to(:title) }
    it {should respond_to(:url) }
  end

  describe "associations" do
    it { should respond_to(:user) }
    it { should respond_to(:categories) }
    it { should respond_to(:items) }
    it { should respond_to(:categorizations) }
  end

  describe "validations" do
    it { should be_valid }

    it "rejects blank title" do
      feed.title = ""
      expect(feed).to be_invalid
    end

    it "rejects duplicate title from same user" do
      feed.user_id = user.id
      feed.save
      dup_feed = build(:feed, title: feed.title, user: user)
      expect(dup_feed.save).to be false
    end

    it "accepts duplicate title from different user" do
      feed.user_id = user.id
      feed.save
      dup_feed = build(:feed, title: feed.title, user: user_2)
      expect(dup_feed.save).to be true
    end

    it "rejects blank url" do
      feed.url = ""
      expect(feed).to_not be_valid
    end
    
    it "accepts duplicate url from different user" do
      feed.user_id = user.id
      feed.save
      dup_feed = build(:feed, url: feed.url, user: user_2)
      expect(dup_feed.save).to be true
    end

    it "rejects duplicate url from same user" do
      feed.user_id = user.id
      feed.save
      dup_feed = build(:feed, url: feed.url, user: user)
      expect(dup_feed.save).to be false
    end
  end

  describe "#fetch" do
    context "success" do
      it "returns xml from feed instance" do
        feed.save
        stub_request(:any, feed.url).to_rack(FakeService)
        xml = feed.fetch(last_modified: feed.last_modified , etag: feed.etag)
        expect(xml.body).not_to be nil 
        expect(xml.class).to be HTTParty::Response
      end
    end

    context "conditional GET request cache headers match" do
      it "returns nil and 304 Not Modified code" do
        feed.last_modified = "Tue, 01 Nov 2016 18:39:41 GMT"
        feed.etag = "\"5818e16d-84069\""
        feed.save
        stub_request(:any, feed.url).to_rack(FakeService)
        xml = feed.fetch(last_modified: feed.last_modified, etag: feed.etag)
        expect(xml.body).to be nil 
        expect(xml.code).to be 304
      end
    end


  end

  describe "#parse" do
    it "returns parsed feed object from xml" do
      feed.save
      stub_request(:any, feed.url).to_rack(FakeService)
      xml = feed.fetch(last_modified: feed.last_modified , etag: feed.etag)
      parsed_feed = feed.parse(xml.body)
      expect(parsed_feed).not_to be nil 
      expect(parsed_feed.entries.count).to eq 202
    end
  end

  describe '#fetch_and_save_new_items' do
    it 'fetches feed xml and saves new items to database' do
      feed.save
      stub_request(:any, feed.url).to_rack(FakeService)
      feed.fetch_and_save_new_items
      expect(Item.count).to eq 30 
    end
  end
end
