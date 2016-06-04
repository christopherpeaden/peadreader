class ItemBroadcastJob < ApplicationJob
  queue_as :default

  def perform(item)
    ActionCable.server.broadcast 'feeds_update_status_channel', item: render_item(item)
  end

  private

    def render_item(item)
      ApplicationController.renderer.render(partial: 'items/item', locals: { item: item })
    end

end
