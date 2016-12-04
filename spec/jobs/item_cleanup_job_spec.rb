require 'rails_helper'

RSpec.describe ItemCleanupJob, type: :job do
  describe "database item cleanup" do
    it "should reduce item count to 30 of the most recently published" do
      user = create(:user)
      feed = create(:feed, user: user)
      35.times {create(:item, feed: feed)}
      expect(Item.count).to eq 35
      ItemCleanupJob.perform_now(user)
      expect(Item.count).to eq 30
    end
  end
end
