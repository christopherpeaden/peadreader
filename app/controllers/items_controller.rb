class ItemsController < ApplicationController
  before_action :find_item, except: [:index, :favorites, :saved_for_later]
  before_action :get_categories, only: [:index, :favorites, :saved_for_later]

  def index
    @items = current_user.items.order(published_at: :desc)
    @items = @items.paginate(page: params[:page], per_page: 30)
  end

  def add_to_favorites
    @item.update(favorite: true)
  end

  def favorites
    @items = current_user.items.where(favorite: true)
  end

  def save_for_later
    @item.update(saved_for_later: true) 
  end

  def saved_for_later
    @items = current_user.items.where(saved_for_later: true)
  end

  def remove_from_favorites
    @item.update(favorite: false) 
  end

  def remove_from_saved_for_later
    @item.update(saved_for_later: false) 
  end

  private

    def find_item
      @item = Item.find(params[:id])
    end

    def get_categories
      @categories = current_user.categories.order(:title)
    end
end
