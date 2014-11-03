class ProductsController < ApplicationController
  def index
   @products = Product.all
  end
  def new
    @product = Product.new
  end

  def create
     @product = current_user.products.build(product_params)
      if @product.save
        subcat = @product.subcat_id
        @category = Category.find(subcat)
        @product.post!(@product.user, @category)
        flash[:notice] = "product was saved."
        redirect_to [@category, @product]
      else
        flash[:error] = "There was an error saving the product. Please try again."
        redirect_to [@category, @product]
      end
    end
    private
    def product_params
    params.require(:product).permit(:title, :price, :link, :description, :category_id, :subcat_id, :image)
   end
end
