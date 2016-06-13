# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class FeedsUpdateStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "feeds_update_status_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update
    current_user.feeds.each do |feed|
      ActionCable.server.broadcast("feeds_update_status_channel", "Updating #{feed.title}...")
      fetch_feed_items(feed)
      ActionCable.server.broadcast(
        "feeds_update_status_channel",
        "Feeds have been successfully updated."
      ) if feed == current_user.feeds.last
    end
  end
end
