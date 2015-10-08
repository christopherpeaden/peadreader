require 'rails_helper'

RSpec.describe "Feed refresh" do

  let(:user) { create(:user) }

  before(:each) do
    sign_in_valid_user(user)
  end
  
  it 'is successful' do
    parsed_feed = Feedjira::Feed.fetch_and_parse('file:///home/peady/Development/rails/projects/feed_reader/spec/support/sample_xml.rss')
  end
end
