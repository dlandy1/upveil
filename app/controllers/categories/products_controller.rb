class Categories::ProductsController < ApplicationController
   before_action :load_activities
   def notifications
    if current_user
      @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
    end
  end
    def purchase
     @user = current_user
     @category = Category.friendly.find(params[:category_id])
     @product = Product.friendly.find(params[:product_id])
     @product.update_attributes(purchase: true)
     @product.create_activity :create, owner: current_user,  recipient: @product.user
     respond_with(@activities) do |format|
          format.html { redirect_to @product.link}
    end
  end
  def show
    @product = Product.friendly.find(params[:id])
  end

   def edit
      @category = Category.friendly.find(params[:category_id])
      @product = Product.friendly.find(params[:id])
    end
   private

    def load_activities
      if current_user
        @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
      end
    end

   def product_params
    params.require(:product).permit(:title, :price, :link, :description, :gender, :category_id, :subcat_id, :image, :image_cache, :remote_image_url)
   end
end
