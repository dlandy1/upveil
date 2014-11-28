require 'json'
class CategoriesController < ApplicationController
  before_action :load_activities

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
        @products = @subcatparent.products.order("rank DESC").where.not(:gender => "Female").where(subcat_id: @category.id).page(params[:page]).per(10)
    else
        @products = @category.products.where.not(:gender => "Female").order("rank DESC").page(params[:page]).per(10)
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
        @unscope = @subcatparent.products.order("created_at DESC").where.not(:gender => "Female").where(subcat_id: @category.id).page(params[:page]).per(10)
    else
        @unscope = @category.products.where.not(:gender => "Female").order("created_at DESC").page(params[:page]).per(10)
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
        @products = @subcatparent.products.order("rank DESC").where.not(:gender => "Male").where(subcat_id: @category.id).page(params[:page]).per(10)
    else
        @products = @category.products.where.not(:gender => "Male").order("rank DESC").page(params[:page]).per(10)
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
        @unscope = @subcatparent.products.order("created_at DESC").where.not(:gender => "Male").where(subcat_id: @category.id).page(params[:page]).per(10)
    else
        @unscope = @category.products.where.not(:gender => "Male").order("created_at DESC").page(params[:page]).per(10)
    end
  end


 def category_params
  params.require(:category).permit(:title)
 end

private

    def load_activities
      if current_user
        @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
      end
    end

end
