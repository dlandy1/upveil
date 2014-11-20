require 'json'
class CategoriesController < ApplicationController

  def show
     @category = Category.friendly.find(params[:id])
     @id= @category.id
     @subcategories = @category.subcategories
     @parent = @category.parent_id
     @category.leaderboard.page_size = 10
     @leaders = @category.leaderboard.leaders(1)
     @users = @category.leaderboard.leaders(1)
     if !@parent.nil?
      @subcatparent = Category.friendly.find(@parent)
      @parentsubcats = @subcatparent.subcategories
      @products = Product.where(subcat_id: @category.id).order('rank DESC').page(params[:page]).per(10)
    else
       @products = @category.products.order('rank DESC').page(params[:page]).per(10)
    end
  end

  def newest
     @category = Category.friendly.find(params[:category_id])
     @subcategories = @category.subcategories
     @parent = @category.parent_id
     @category.leaderboard.page_size = 10
     @leaders = @category.leaderboard.leaders(1)
     @users = @category.leaderboard.leaders(1)
    if !@parent.nil?
      @subcatparent = Category.friendly.find(@parent)
      @parentsubcats = @subcatparent.subcategories
      @unscope = Product.order("created_at DESC").where(subcat_id: @category.id).page(params[:page]).per(10)
    else
       @unscope = @category.products.order("created_at DESC").page(params[:page]).per(10)
    end
  end

  def male
    @category = Category.friendly.find(params[:category_id])
    @subcategories = @category.subcategories.where(:gender => nil)
    @parent = @category.parent_id
    @category.leaderboard.page_size = 10
    @leaders = @category.leaderboard.leaders(1)
    @users = @category.leaderboard.leaders(1)
    if !@parent.nil?
        @subcatparent = Category.friendly.find(@parent)
        @parentsubcats = @subcatparent.subcategories.where(:gender => nil)
        @products = @subcatparent.products.order("rank DESC").where(:gender => "Male").where(subcat_id: @category.id).page(params[:page]).per(10)
    else
        @products = @category.products.where(:gender => "Male").order("rank DESC").page(params[:page]).per(10)
    end
  end

  def male_newest
    @category = Category.friendly.find(params[:category_id])
    @subcategories = @category.subcategories.where(:gender => nil)
    @parent = @category.parent_id
    @category.leaderboard.page_size = 10
    @leaders = @category.leaderboard.leaders(1)
    @users = @category.leaderboard.leaders(1)
    if !@parent.nil?
        @subcatparent = Category.friendly.find(@parent)
        @parentsubcats = @subcatparent.subcategories
        @unscope = @subcatparent.products.order("created_at DESC").where(:gender => "Male").where(subcat_id: @category.id).page(params[:page]).per(10)
    else
        @unscope = @category.products.where(:gender => "Male").order("created_at DESC").page(params[:page]).per(10)
    end
  end

  def female
    @category = Category.friendly.find(params[:category_id])
    @subcategories = @category.subcategories
    @parent = @category.parent_id
    @category.leaderboard.page_size = 10
    @leaders = @category.leaderboard.leaders(1)
    @users = @category.leaderboard.leaders(1)
    if !@parent.nil?
        @subcatparent = Category.friendly.find(@parent)
        @parentsubcats = @subcatparent.subcategories
        @products = @subcatparent.products.order("rank DESC").where(:gender => "Female").where(subcat_id: @category.id).page(params[:page]).per(10)
    else
        @products = @category.products.where(:gender => "Female").order("rank DESC").page(params[:page]).per(10)
    end
  end

  def female_newest
    @category = Category.friendly.find(params[:category_id])
    @subcategories = @category.subcategories
    @parent = @category.parent_id
    @category.leaderboard.page_size = 10
    @leaders = @category.leaderboard.leaders(1)
    @users = @category.leaderboard.leaders(1)
    if !@parent.nil?
        @subcatparent = Category.friendly.find(@parent)
        @parentsubcats = @subcatparent.subcategories
        @unscope = @subcatparent.products.order("created_at DESC").where(:gender => "Male").where(subcat_id: @category.id).page(params[:page]).per(10)
    else
        @unscope = @category.products.where(:gender => "Male").order("created_at DESC").page(params[:page]).per(10)
    end
  end


 def category_params
  params.require(:category).permit(:title)
 end


end
