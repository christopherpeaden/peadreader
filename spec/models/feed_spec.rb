require 'rails_helper'

RSpec.describe Feed do

  subject { build(:feed) } 
  let(:feed) { subject }

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

    it "rejects duplicate title" do
      feed.save
      dup_feed = build(:feed, title: feed.title)
      expect(dup_feed.save).to be false
    end

    it "rejects blank url" do
      feed.url = ""
      expect(feed).to_not be_valid
    end
    
    it "rejects duplicate url" do
      feed.save
      dup_feed = build(:feed, url: feed.url)
      expect(dup_feed.save).to be false
    end
  end
end
