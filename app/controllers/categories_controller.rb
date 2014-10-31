class CategoriesController < ApplicationController
  def show
     @category = Category.find(params[:id])
     @subcategories = @category.subcategories
     @parent = @category.parent_id
     @products = @category.products
  end

  def new
  end

  def edit
  end
end
