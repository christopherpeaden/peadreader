class ItemBroadcastJob < ApplicationJob
  queue_as :default

  def perform(item)
    ActionCable.server.broadcast "feeds_update_status_channel_user_#{find_verified_user.id}", item: render_item(item)
  end

  private

    def render_item(item)
      ApplicationController.renderer.render(partial: 'items/item', locals: { item: item })
    end
end
