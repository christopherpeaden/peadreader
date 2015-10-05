require 'rails_helper'

RSpec.describe Feed do

  describe "messages" do
    it { should respond_to(:id) }
    it { should respond_to(:title) }
    it { should respond_to(:url) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe "validation" do

    subject { build(:feed) }
    let(:feed) { subject }
    
    it { should be_valid }

    it "rejects blank title" do
      feed.title = ""
      expect(feed).to_not be_valid
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
