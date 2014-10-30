class Categories::ProductsController < ApplicationController
  def show
    @category = Category.find(params[:category_id])
    @product = Product.find(params[:id])
  end

  def new
    @category = Category.find(params[:category_id])
    @product = Product.new
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

  def edit
  end
end
