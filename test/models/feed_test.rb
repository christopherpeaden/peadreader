require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  def setup
    @feed = Feed.new(title: "some_title", url: "some_url")
  end

  test "empty feed attributes are not allowed" do
    @empty_feed = Feed.new

    assert @feed.valid?
    assert_not @empty_feed.valid?
  end

  test "title cannot be blank" do
    @feed.update(title: " ")
    assert_not @feed.valid?
  end

  test "url cannot be blank" do
    @feed.update_attributes(url: " ")
    assert_not @feed.valid?
  end

  #test "feed item can be retrieved for specific users" do
    #@user = users(:chris)
    #assert_not Feed.get_feed_items_from_current_user(@user.feeds).empty?
  #end
end
