require 'json'
class CategoriesController < ApplicationController

  def show
     @category = Category.friendly.find(params[:id])
     @subcategories = @category.subcategories
     @parent = @category.parent_id
     @leaders = @category.leaderboard.leaders(1)
     @users = @category.leaderboard.leaders(1, {:with_member_data => true})
     if @category.title == "Fashion"
      @products = @category.products.order('rank DESC').page(params[:page]).per(10)
      @maleproducts = @category.products.where(:gender => "Male").order('rank DESC').page(params[:page]).per(10)
      @femaleproducts  = @category.products.where(:gender => "Female").order('rank DESC').page(params[:page]).per(10)
      @unscopemale = @category.products.where(:gender => "Male").order("created_at DESC").page(params[:page]).per(15)
      @femaleunscope = @category.products.order("created_at DESC").where(:gender => "Female").page(params[:page]).per(15)
     elsif !@parent.nil?
      @subcatparent = Category.friendly.find(@parent)
      @parentsubcats = @subcatparent.subcategories
      if @subcatparent.title == "Fashion"
        @products = Product.where(subcat_id: @category.id).order('rank DESC').page(params[:page]).per(10)
        @maleproducts = @subcatparent.products.where(:gender => "Male").where(subcat_id: @category.id).order('rank DESC').page(params[:page]).per(10)
        @femaleproducts  = @subcatparent.products.where(:gender => "Female").where(subcat_id: @category.id).order("rank DESC").page(params[:page]).per(10)
        @unscopemale = @subcatparent.products.order("created_at DESC").where(:gender => "Male").where(subcat_id: @category.id).page(params[:page]).per(15)
        @femaleunscope = @subcatparent.products.order("created_at DESC").where(:gender => "Female").where(subcat_id: @category.id).page(params[:page]).per(15)
        @unscope = Product.order("created_at DESC").where(subcat_id: @category.id).page(params[:page]).per(15)
      else
        @products = Product.where(subcat_id: @category.id).order('rank DESC').page(params[:page]).per(10)
        @unscope = Product.order("created_at DESC").where(subcat_id: @category.id).page(params[:page]).per(15)
      end
    else
       @products = @category.products.order('rank DESC').page(params[:page]).per(10)
       @unscope = @category.products.order("created_at DESC").page(params[:page]).per(15)
    end
  end


 def category_params
  params.require(:category).permit(:title)
 end


end
