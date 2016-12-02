# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class FeedsUpdateStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "feeds_update_status_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update
    feeds_with_errors = []
    current_user.feeds.each do |feed|
      ActionCable.server.broadcast("feeds_update_status_channel", "Updating #{feed.title}...")
      begin
        feed.fetch_and_save_new_items
      rescue
        feeds_with_errors << feed.title
      end
      broadcast_status(feeds_with_errors) if feed == current_user.feeds.last
    end
  end

    private
      def broadcast_status(feed_titles)
        if feed_titles.empty?
          update_successful_message
        else
          update_failure_message(feed_titles)
        end
      end

      def update_successful_message
        ActionCable.server.broadcast(
          "feeds_update_status_channel",
          "Feeds have been successfully updated."
        ) 
      end

      def update_failure_message(feed_titles)
        ActionCable.server.broadcast(
          "feeds_update_status_channel",
          "There was a problem with the following #{ActionController::Base.helpers.pluralize(feed_titles.count, 'feed')}: #{feed_titles.join(', ')}."
        ) 
      end
end
