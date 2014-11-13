class SubcategoriesController < ApplicationController

  def index
    category = Category.friendly.find(params[:category_id])
    respond_to do |format|
      format.json { render :json => category.subcategories }
    end
  end
end
