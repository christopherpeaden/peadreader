class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  before_action :get_categories, only: [:show, :create, :update, :new, :edit, :index, :destroy]
  before_action :authenticate_user!

  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)
    @category.save
  end

  def show
    arr = []
    @feeds = @category.feeds
    @feeds.each {|feed| feed.items.each { |item| arr << item } }
    @items = arr.sort! { |x,y| y.published_at <=> x.published_at }
    @items = @items.paginate(page: params[:page])
  end

  def index
  end

  def edit
  end

  def update
    @category.update_attributes(category_params)
  end

  def destroy
    @category.destroy
  end


  private

    def find_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:title)
    end

    def get_categories
      @categories = current_user.categories.order(:title)
    end
end
