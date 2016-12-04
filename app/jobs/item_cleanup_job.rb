class ItemCleanupJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.feeds.each do |feed|
      items = Array(feed.items.order(published_at: :desc))
      if items.count > 30
        items_over = items.slice(30..-1)
        items_over.each {|item| item.destroy} 
      end
    end
  end

end
