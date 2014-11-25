class ProductsController < ApplicationController
  def index
   @products = Product.order('rank DESC').page(params[:page]).per(10)
   @leaders =  HIGHSCORE_LB.leaders(1)
  end

  def newest
     @unscopes =  Product.order('created_at DESC').page(params[:page]).per(10)
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
        @product.tweet
        @product.update_rank
        @product.increase(current_user, 100)
        subcat = @product.subcat_id
        @product.up_vote!(@product.user)
        @category = Category.friendly.find(subcat)
        @category.increase_grade(current_user, 100)
        flash[:notice] = "Product was saved."
        redirect_to [@category]
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
    def product_params
    params.require(:product).permit(:title, :price, :link, :description, :gender, :category_id, :subcat_id, :image, :remote_image_url)
   end
end
