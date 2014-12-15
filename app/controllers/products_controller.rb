class ProductsController < ApplicationController
  before_action :load_activities
  respond_to :html, :js
  def notifications
    if current_user
      @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
    end
  end
  
  def index
   @products = Product.where.not(category_id: Category.where(adult: true).ids).order('created_at DESC').page(params[:page]).per(10)
   @leaders =  HIGHSCORE_LB.leaders(1)
  end

  def newest
     @unscopes =  Product.where.not(category_id: Category.where(adult: true).ids).order('created_at DESC').page(params[:page]).per(10)
     @leaders =  HIGHSCORE_LB.leaders(1)
  end
  
  def new
    if current_user != nil
      @product = Product.new
     else
       flash[:error] = "You must sign in before posting a product."
       redirect_to new_user_session_path
    end
  end

  def edit
      @category = Category.friendly.find(params[:category_id])
      @product = Product.friendly.find(params[:id])
  end

def create
     @product = current_user.products.build(product_params)
      if @product.save
        @cat = @product.category
        if current_user != @cat.user
          @cat.create_activity :update, owner: current_user,  recipient: @cat.user_id
          @cat.top
        end
        if @product.subcat_id
        @sub = Category.friendly.find(@product.subcat_id)
         if current_user != @sub.user
          @sub.create_activity :update, owner: current_user,  recipient: @sub.user_id
          @sub.top
         end
        end
        if @product.grandcat_id
            @grand =  Category.find(@product.grandcat_id)
            @grand.top
           if current_user != @grand.user
          @grand.create_activity :update, owner: current_user,  recipient: @grand.user
          end
        end
        @product.update_rank
        @product.increase(current_user, 100)
        @product.up_vote!(@product.user)
        if @product.subcat_id
          subcat = @product.subcat_id
          @category = Category.friendly.find(subcat)
          @category.increase_grade(current_user, 100)
        respond_with(@activities) do |format|
          format.html { redirect_to @category}
        end
      else
         respond_with(@activities) do |format|
          format.html { redirect_to @product.category}
        end
      end
      else
        flash[:error] = "There was an error saving the product. Please try again."
        render :edit
      end
  end

    def update
      @product = Product.friendly.find(params[:id])
      @category = @product.category
       if @product.update_attributes(product_params)
         flash[:notice] = "Post was updated."
         redirect_to [@category, @product]
       else
         flash[:error] = "There was an error saving the post. Please try again."
         render :edit
       end
   end
   
   def destroy
    @product = Product.friendly.find(params[:id])
    @category = @product.category
    subcat = @product.subcat_id
    @subcategory = Category.friendly.find(subcat)
    if current_user == @product.user || current_user.id == 1 || current_user.id == 2 || current_user.id == 3
      if @product.destroy
        PublicActivity::Activity.where(trackable_id: @product.id).destroy_all
        @product.increase(@product.user, -100)
        @category.increase_grade(@product.user, -100)
        flash[:notice] = "#{@product.title} was deleted successfully."
        redirect_to  @subcategory
      else 
        flash[:error] = "There was an error deleting the post."
        redirect_to [@category, @product]
      end
     else 
        flash[:error] = "There was an error deleting the post."
        redirect_to [@category, @product]
      end
   end

    private

    def load_activities
      if current_user
        @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
      end
    end

    def product_params
    params.require(:product).permit(:title, :price, :link, :description, :gender, :holiday, :category_id, :subcat_id, :grandcat_id, :image, :remote_image_url)
   end
end
