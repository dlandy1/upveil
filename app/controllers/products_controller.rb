class ProductsController < ApplicationController
  def index
   @products = Product.all
   @leaders =  HIGHSCORE_LB.leaders(1)
  end
  
  def new
    if current_user != nil
    @product = Product.new
     else
       flash[:error] = "You must sign in or up before posting a product."
       redirect_to new_user_session_path
    end
  end

  def create
     @product = current_user.products.build(product_params)
      if @product.save
        subcat = @product.subcat_id
        @product.up_vote!(@product.user)
        @category = Category.find(subcat)
        @category.increase_grade(current_user, 100)
        flash[:notice] = "product was saved."
        redirect_to [@category, @product]
      else
        flash[:error] = "There was an error saving the product. Please try again."
        redirect_to [@category, @product]
      end
  end

    def update
      @product = Product.find(params[:id])
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
    @product = Product.find(params[:id])
    @category = @product.category
    subcat = @product.subcat_id
    @subcategory = Category.find(subcat)

    if @product.destroy
      @category.increase_grade(current_user, -100)
      flash[:notice] = "#{@product.title} was deleted successfully."
      redirect_to  @subcategory
    else 
      flash[:error] = "There was an error deleting the post."
      render :show
    end
   end

    private
    def product_params
    params.require(:product).permit(:title, :price, :link, :description, :gender, :category_id, :subcat_id, :image)
   end
end
