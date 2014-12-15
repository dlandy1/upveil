class Categories::ProductsController < ApplicationController
   before_action :load_activities
   respond_to :html, :js
   def notifications
    if current_user
      @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
    end
  end

    def purchase
     @user = current_user
     @category = Category.friendly.find(params[:category_id])
     @product = Product.friendly.find(params[:product_id])
      if @user != @product.user
     @product.create_activity :purchase, owner: current_user,  recipient: @product.user
     respond_with(@activities) do |format|
          format.html { redirect_to @product.link}
    end
    else
      redirect_to @product.link
    end
  end

  def new
    if current_user != nil
      @category = Category.friendly.find(params[:category_id])
      @product = Product.new
     else
       flash[:error] = "You must sign in before posting a product."
       redirect_to new_user_session_path
    end
  end

  def create
     @product = current_user.products.build(product_params)
      if @product.save
        @cat = @product.category
        if current_user != @cat.user
          @cat.create_activity :update, owner: current_user,  recipient: @cat.user
        end
        @sub = Category.friendly.find(@product.subcat_id)
         if current_user != @sub.user
          @sub.create_activity :update, owner: current_user,  recipient: @sub.user
         end
        if @product.grandcat_id
            @grand =  Category.friendly.find(@product.grandcat_id)
           if current_user != @grand.user
          @grand.create_activity :update, owner: current_user,  recipient: @grand.user
          end
        end
        @product.update_rank
        @product.increase(current_user, 100)
        subcat = @product.subcat_id
        @product.up_vote!(@product.user)
        @category = Category.friendly.find(subcat)
        @category.increase_grade(current_user, 100)
        flash[:notice] = "Product was saved."
        respond_with(@activities) do |format|
          format.html { redirect_to[@category, :newest]}
        end
      else
        flash[:error] = "There was an error saving the product. Please try again."
        render :edit
      end
  end

  def show
    @product = Product.friendly.find(params[:id])
  end

   def edit
      @category = Category.friendly.find(params[:category_id])
      @product = Product.friendly.find(params[:id])
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

   private

    def load_activities
      if current_user
        @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
      end
    end

   def product_params
    params.require(:product).permit(:title, :price, :link, :description, :gender, :holiday, :category_id, :subcat_id, :grandcat_id, :image, :image_cache, :remote_image_url)
   end
end
