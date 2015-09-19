require 'rails_helper'

RSpec.describe Feed, type: :model do

  let(:feed) { build(:feed) }
  
  describe "feed attributes" do

    it "has valid attributes" do
      expect(feed).to be_valid
    end

    it "rejects blank feed titles" do
      feed.title = ""
      expect(feed).to_not be_valid
    end

    it "rejects blank feed url" do
      feed.url = ""
      expect(feed).to_not be_valid
    end
  end

  describe "associations" do

    it "belongs to user" do
      expect(feed).to respond_to(:user) 
    end

    it "belongs to category" do
      expect(feed).to respond_to(:category)
    end

    it "has many items" do
      expect(feed).to respond_to(:items)
    end
  end
end
