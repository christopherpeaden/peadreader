require 'rails_helper'

RSpec.describe Feed do

  describe "validation" do

    subject { build(:feed) }
    let(:feed) { subject }
    
    it { should be_valid }

    it "rejects blank title" do
      feed.title = ""
      expect(feed).to_not be_valid
    end

    it "rejects blank url" do
      feed.url = ""
      expect(feed).to_not be_valid
    end

    it "rejects another feed with same title" do
      feed.save
      second_feed = build(:feed)
      second_feed.title = feed.title
      expect(second_feed).to_not be_valid
    end
  end

  describe "associations" do
    it { should respond_to(:user) }
    it { should respond_to(:category) }
    it { should respond_to(:items) }
  end
end
