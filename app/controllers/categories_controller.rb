class CategoriesController < ApplicationController
  before_action :get_categories 
  before_action :authenticate_user!
  before_action :find_category, except: [:new, :create, :index]

  def new
    @category = Category.new
  end

  def create
    arr = []
    @category = current_user.categories.build(category_params)
    if @category.save
      flash[:success] = "Category saved successfully."
      redirect_to @category
    else
      flash.now[:danger] = "There was a problem saving your category."
      render 'new'
    end
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
    if @category.update_attributes(category_params)
      flash[:success] = "Category updated successfully."
      redirect_to @category
    else
      flash.now[:danger] = "There was a problem saving your category."
      render 'edit'
    end
  end

  def destroy
    flash[:success] = "Category deleted successfully."
    @category.destroy
    redirect_to categories_path
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
