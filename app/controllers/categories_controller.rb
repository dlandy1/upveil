class CategoriesController < ApplicationController

  def new
    @category = Category.new
  end


  def show
     @category = Category.find(params[:id])
     @subcategories = @category.subcategories
     @parent = @category.parent_id
     @products = @category.products
  end

  def edit
    @category = Category.find(params[:id])
    authorize @category
  end


  def create
    @category = Category.new(topic_params)
    if @category.save
      redirect_to @category, notice: "Topic was saved successfully."
    else
      flash[:error] = "Error creating topic. Please try again."
      render :new
    end
  end

 def update
  @category = Category.find(params[:id])
  authorize @category
  if @category.update_attributes(category_params)
    redirect_to @category
  else
    flash[:error] = "There was an error updating the topic. Please try again."
    render :edit
  end
 end

 def destroy
  @category = Category.find(params[:id])
  name = @category.title

  authorize @category
  if @category.delete
     flash[:notice] = "\"#{name}\" was deleted successfully."
     redirect_to categories_path
  else
    flash[:error] = "There was an error deleting the topic."
    render :show
  end
 end

 def category_params
  params.require(:category).permit(:title)
 end


end
