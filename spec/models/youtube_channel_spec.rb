require 'rails_helper'

RSpec.describe YoutubeChannel, type: :model do

  let(:youtube_channel) { build(:youtube_channel) }

  describe "validation" do
    it "has a valid factory" do
      expect(youtube_channel).to be_valid
    end

    it "has many youtube videos" do
      expect(youtube_channel).to respond_to(:youtube_videos)
    end

    it "rejects blank title" do
      youtube_channel.title = ""
      expect(youtube_channel).to be_invalid
    end
    
    it "rejects duplicate title" do
      youtube_channel.save
      dup_youtube_channel = build(:youtube_channel, title: youtube_channel.title)
      expect(dup_youtube_channel).to respond_to(:youtube_videos)
    end
  end
end
