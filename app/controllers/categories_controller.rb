class CategoriesController < ApplicationController
  def show
     @category = Category.find(params[:id])
     @products = @category.products
  end

  def new
  end

  def edit
  end
end
