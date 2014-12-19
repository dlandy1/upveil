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

   def destroy
    @product = Product.friendly.find(params[:id])
    @category = @product.category
    if current_user == @product.user || current_user.id == 1 || current_user.id == 2 || current_user.id == 3
      if @product.destroy
        PublicActivity::Activity.where(trackable_id: @product.id).destroy_all
        @product.increase(@product.user, -100)
        @category.increase_grade(@product.user, -100)
        flash[:notice] = "#{@product.title} was deleted successfully."
        redirect_to  @category
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
    params.require(:product).permit(:title, :price, :link, :description, :gender, :holiday, :category_id, :subcat_id, :grandcat_id, :image, :image_cache, :remote_image_url)
   end
end
