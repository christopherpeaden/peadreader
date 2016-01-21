require 'rails_helper'

RSpec.describe Feed do

  describe "validation" do

    let(:feed) { build(:feed) }
    
    it "has a valid factory" do
      expect(feed).to be_valid
    end

    it "rejects blank title" do
      feed.title = ""
      expect(feed).to be_invalid
    end

    it "rejects duplicate title" do
      feed.save
      duplicate_feed = build(:feed, title: feed.title)
      expect(duplicate_feed.save).to be false
    end

    it "rejects blank url" do
      feed.url = ""
      expect(feed).to_not be_valid
    end
    
    it "rejects duplicate url" do
      feed.save
      duplicate_feed = build(:feed, url: feed.url)
      expect(duplicate_feed.save).to be false
    end

  end

  describe "associations" do
    it { should respond_to(:user) }
    it { should respond_to(:category) }
    it { should respond_to(:items) }
  end
end
