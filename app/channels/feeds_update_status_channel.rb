# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class FeedsUpdateStatusChannel < ApplicationCable::Channel
  attr_reader
  def subscribed
    stream_from user_stream_name(current_user.id) 
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update
    feeds_with_errors = []
    current_user.feeds.each do |feed|
      ActionCable.server.broadcast(user_stream_name(current_user.id), "Updating #{feed.title}...")
      begin
        feed.fetch_and_save_new_items
      rescue
        feeds_with_errors << feed.title
      end
      broadcast_status(feeds_with_errors) if feed == current_user.feeds.last
    end
    ItemCleanupJob.perform_now(current_user)
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
          user_stream_name(current_user.id),
          "Feeds have been successfully updated."
        ) 
      end

      def update_failure_message(feed_titles)
        ActionCable.server.broadcast(
          user_stream_name(current_user.id),
          "There was a problem with the following #{ActionController::Base.helpers.pluralize(feed_titles.count, 'feed')}: #{feed_titles.join(', ')}."
        ) 
      end

      def user_stream_name(user_id)
        "feeds_update_status_channel_user_#{user_id}"
      end
end
