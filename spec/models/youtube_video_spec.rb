require 'rails_helper'

RSpec.describe YoutubeVideo, type: :model do

  let(:youtube_video) { build(:youtube_video) }

  describe "validation" do
    it "has a valid factory" do
      expect(youtube_video).to be_valid
    end
  end
end
