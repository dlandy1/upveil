class ProductsController < ApplicationController
  def index
   @products = Product.all
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
    private
    def product_params
    params.require(:product).permit(:title, :price, :link, :description, :category_id, :subcat_id, :image, :image_cache, :remote_image_url)
   end
end
