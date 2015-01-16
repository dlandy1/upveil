require 'json'
class CategoriesController < ApplicationController
  before_action :load_activities
   respond_to :html, :js
  def show
     @category = Category.friendly.find(params[:id])
     @id= @category.id
     @subcategories = @category.subcategories.order('rank DESC').page(params[:page]).per(8)
     @parent = @category.parent_id
     @category.leaderboard.page_size = 10
     @leaders = @category.leaderboard.leaders(1)
     @users = @category.leaderboard.leaders(1)
     if !@parent.nil?
      if @category.parent_category.parent_category
         @products = Product.where(grandcat_id: @category.id).order('rank DESC').page(params[:page]).per(10)
      else
         @products = Product.where(subcat_id: @category.id).order('rank DESC').page(params[:page]).per(10)
      end
      @subcatparent = Category.friendly.find(@parent)
      @parentsubcats = @subcatparent.subcategories.order('rank DESC')
    else
       @products = @category.products.order('rank DESC').page(params[:page]).per(10)
    end
     respond_to do |format|
      format.html
      format.js 
    end
  end

  def newest
     @category = Category.friendly.find(params[:category_id])
     @subcategories = @category.subcategories.order('rank DESC')
     @parent = @category.parent_id
     @category.leaderboard.page_size = 10
     @leaders = @category.leaderboard.leaders(1)
     @users = @category.leaderboard.leaders(1)
    if !@parent.nil?
      @subcatparent = Category.friendly.find(@parent)
      @parentsubcats = @subcatparent.subcategories.order('rank DESC').page(params[:page]).per(7)
      if @category.parent_category.parent_category
      @unscope = Product.order("created_at DESC").where(grandcat_id: @category.id).page(params[:page]).per(10)
      else
      @unscope = Product.order("created_at DESC").where(subcat_id: @category.id).page(params[:page]).per(10)
    end
    else
       @unscope = @category.products.order("created_at DESC").page(params[:page]).per(10)
    end
  end

  def male
    @category = Category.friendly.find(params[:category_id])
    @subcategories = @category.subcategories.where(gender: nil)
    @parent = @category.parent_id
    @category.leaderboard.page_size = 10
    @leaders = @category.leaderboard.leaders(1)
    @users = @category.leaderboard.leaders(1)
    if !@parent.nil?
        @subcatparent = Category.friendly.find(@parent)
        @parentsubcats = @subcatparent.subcategories
        @products = @subcatparent.products.order("rank DESC").where.not(:gender => "Female").where(subcat_id: @category.id).page(params[:page]).per(10)
    else
        @products = @category.products.where.not(:gender => "Female").order("rank DESC").page(params[:page]).per(10)
    end
  end

  def male_newest
    @category = Category.friendly.find(params[:category_id])
    @subcategories = @category.subcategories.where(gender: nil).order('rank DESC')
    @parent = @category.parent_id
    @category.leaderboard.page_size = 10
    @leaders = @category.leaderboard.leaders(1)
    @users = @category.leaderboard.leaders(1)
    if !@parent.nil?
        @subcatparent = Category.friendly.find(@parent)
        @parentsubcats = @subcatparent.subcategories.where(gender: nil)
    if @category.parent_category.parent_category
        @unscope = Product.order("created_at DESC").where.not(:gender => "Female").where(grandcat_id: @category.id).page(params[:page]).per(10)
    else
        @unscope = @subcatparent.products.order("created_at DESC").where.not(:gender => "Female").where(subcat_id: @category.id).page(params[:page]).per(10)
    end
    else
        @unscope = @category.products.where.not(:gender => "Female").order("created_at DESC").page(params[:page]).per(10)
    end
  end

  def female
    @category = Category.friendly.find(params[:category_id])
    @subcategories = @category.subcategories.order('rank DESC')
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
    @subcategories = @category.subcategories.order('rank DESC')
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

  def new
    if current_user != nil
      @category = Category.new
     else
       flash[:error] = "You must sign in before creating a category."
       redirect_to new_user_session_path
    end
  end

  def subcategory_new
    if current_user != nil
      @parentcat =  Category.friendly.find(params[:category_id])
      @category = Category.new
    else
       flash[:error] = "You must sign in before creating a category."
       redirect_to new_user_session_path
    end
  end

  def edit
    @category = Category.friendly.find(params[:id])
  end

  def update
  @category = Category.friendly.find(params[:id])
  if current_user == @category.user || current_user.id == 1 || current_user.id == 2 || current_user.id == 3 || current_user.id == 4
  if @category.update_attributes(category_params)
    redirect_to @category
  else
    flash[:error] = "There was an error updating the category. Please try again."
    render :edit
  end
  else
    flash[:error] = "You dont have permission to delete the category."
    render :show
  end
 end

 def destroy
  @category = Category.friendly.find(params[:id])
  name = @category.name
  if current_user.id == 1 || current_user.id == 2 || current_user.id == 3 || current_user.id == 4
  if @category.delete
     flash[:notice] = "\"#{name}\" was deleted successfully."
     redirect_to root_path
  else
    flash[:error] = "There was an error deleting the category."
    render :show
  end
  else
    flash[:error] = "You dont have permission to delete the category."
    render :show
  end
 end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to @category, notice: "Category was saved successfully."
    else
      flash[:error] = "Error creating category. Please try again."
      if @category.parent_id
        @parentcat =  Category.friendly.find(@category.parent_id)
        render :subcategory_new
      else
        render :new
      end
    end
  end


private

  def category_params
  params.require(:category).permit(:title, :description, :parent_id, :user_id, :gendered, :secret, :adult)
 end

    def load_activities
      if current_user
        @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
      end
    end

end
