class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  before_action :get_categories, only: [:show, :new, :edit]
  before_action :authenticate_user!

  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)

    if @category.save
      redirect_to @category
    else
      render 'new'
    end
  end

  def show
  end

  def index
    @categories = current_user.categories
    render json: @categories
  end

  def edit
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to @category
    else
      render 'edit'
    end
  end

  def destroy
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
      @categories = current_user.categories
    end
end
