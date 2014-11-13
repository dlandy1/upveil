require 'json'
class CategoriesController < ApplicationController

  def new
    @category = Category.new
  end

  def show
     @category = Category.friendly.find(params[:id])
     @subcategories = @category.subcategories
     @parent = @category.parent_id
     @leaders = @category.leaderboard.leaders(1)
     @users = @category.leaderboard.leaders(1, {:with_member_data => true})
     if @category.title == "Fashion"
      @maleproducts = @category.products.where(:gender => "Male").order('rank DESC').page(params[:page]).per(10)
      @femaleproducts  = @category.products.where(:gender => "Female").order('rank DESC').page(params[:page]).per(10)
      @unscopemale = @category.products.where(:gender => "Male").order("created_at DESC").page(params[:page]).per(15)
      @femaleunscope = @category.products.order("created_at DESC").where(:gender => "Female").page(params[:page]).per(15)
     elsif !@parent.nil?
      @subcatparent = Category.friendly.find(params[:id])
      @parentsubcats = @subcatparent.subcategories
      if @subcatparent.title == "Fashion"
        @maleproducts = @subcatparent.products.where(:gender => "Male").where(subcat_id: @category.id).order('rank DESC').page(params[:page]).per(10)
        @femaleproducts  = @subcatparent.products.where(:gender => "Female").where(subcat_id: @category.id).order("created_at DESC").page(params[:page]).per(10)
        @unscopemale = @subcatparent.products.order("created_at DESC").where(:gender => "Male").where(subcat_id: @category.id).page(params[:page]).per(15)
        @femaleunscope = @subcatparent.products.order("created_at DESC").where(:gender => "Female").where(subcat_id: @category.id).page(params[:page]).per(15)
      else
        @products = Product.where(subcat_id: @category.id).order('rank DESC').page(params[:page]).per(10)
        @unscope = Product.order("created_at DESC").where(subcat_id: @category.id).page(params[:page]).per(15)
      end
    else
       @products = @category.products.order('rank DESC').page(params[:page]).per(10)
       @unscope = @category.products.order("created_at DESC").page(params[:page]).per(15)
    end
  end

  def edit
    @category = Category.friendly.find(params[:id])
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
  @category = Category.friendly.find(params[:id])
  if @category.update_attributes(category_params)
    redirect_to @category
  else
    flash[:error] = "There was an error updating the topic. Please try again."
    render :edit
  end
 end

 def destroy
  @category = Category.friendly.find(params[:id])
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
