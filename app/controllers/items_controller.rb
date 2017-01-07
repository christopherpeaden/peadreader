class ItemsController < ApplicationController
  before_action :find_item, except: [:index, :favorites, :saved_for_later]
  before_action :get_categories, only: [:index, :favorites, :saved_for_later]

  def index
    @items = current_user.items.order(published_at: :desc)
    @items = @items.paginate(page: params[:page], per_page: 30)
  end

  private

    def find_item
      @item = Item.find(params[:id])
    end

    def get_categories
      @categories = current_user.categories.order(:title)
    end
end
