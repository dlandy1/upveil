class Categories::ProductsController < ApplicationController
  

  def show
    @product = Product.friendly.find(params[:id])
  end

   def edit
      @category = Category.friendly.find(params[:category_id])
      @product = Product.friendly.find(params[:id])
    end
   private

   def product_params
    params.require(:product).permit(:title, :price, :link, :description, :gender, :category_id, :subcat_id, :image, :image_cache, :remote_image_url)
   end
end
