class Categories::ProductsController < ApplicationController
  def show
    @category = Category.find(params[:category_id])
    @product = Product.find(params[:id])
  end

  def new
    @category = Category.find(params[:category_id])
    @product = Product.new
  end

   def edit
      @category = Category.find(params[:category_id])
      @product = Product.find(params[:id])
    end

   def create
     @category = Category.find(params[:category_id])
     @product = current_user.products.build(product_params)
     @product.category = @category
      if @product.save
        flash[:notice] = "product was saved."
        redirect_to [@category, @product]
      else
        flash[:error] = "There was an error saving the product. Please try again."
        render :new
      end
    end

def update
      @category = Category.find(params[:category_id])
      @product = Product.find(params[:id])
       if @product.update_attributes(post_params)
         flash[:notice] = "Post was updated."
         redirect_to [@category, @product]
       else
         flash[:error] = "There was an error saving the post. Please try again."
         render :edit
       end
   end

   def destroy
    @category = Category.find(params[:category_id])
    @product = Product.find(params[:id])

    if @product.destroy
      flash[:notice] = "\"#{title}\" was deleted successfully."
      redirect_to @category
    else 
      flash[:error] = "There was an error deleting the post."
      render :show
    end
   end
   private

   def product_params
    params.require(:product).permit(:title, :price, :link, :description, :image)
   end
end
