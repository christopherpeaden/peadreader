class CategoriesController < ApplicationController
  before_action :find_category, only: [:destroy]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    @category.destroy
    redirect_to(:back)
  end


  private

    def find_category
      @category = Category.find(params[:id])
    end

    def  category_params
      params.require(:category).permit(:title)
    end
end
