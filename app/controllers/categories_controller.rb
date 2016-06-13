class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_categories 
  before_action :find_category, except: [:new, :create, :index]

  def new
    @category = Category.new
  end

  def create
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
    @items = @category.items.order(published_at: :desc)
    @items = @items.paginate(page: params[:page])
  end

  def index
  end

  def edit
  end

  def update
    if @category.update_attributes(category_params)
      flash[:success] = "Category updated successfully."
      @items = @category.items.order(published_at: :desc)
      @items = @items.paginate(page: params[:page])
      redirect_to @category
    else
      flash.now[:danger] = "There was a problem saving your category."
      render 'edit'
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = "Category deleted successfully."
      redirect_to categories_path
    else
      flash[:danger] = "There was a problem deleteing this category."
      render @category
    end
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
