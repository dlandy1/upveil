class CommentsController < ApplicationController
  respond_to :html, :js
  before_action :load_activities

  def create
     @product = Product.friendly.find(params[:product_id])
    @comments = @product.comments

    @comment = current_user.comments.new( comment_params )
     @comment.product = @product
    @new_comment = Comment.new

    if current_user
      if @comment.save
        flash[:notice] = "Comment was created successfully."
      else
        flash[:error] = "Error creating comment."
      end
    end

    respond_with(@commentr) do |format|
      format.html { redirect_to [@product.category, @product] }
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @product = @comment.product
    @category= @product.category
  end

  def update
         @comment = Comment.find(params[:id])
         @product = @comment.product
         @category= @product.category
          if @comment.update_attributes(comment_params)
            redirect_to [@category, @product]
          else
           render :action => "edit" 
          end
      end

  def destroy
    @product = Product.friendly.find(params[:product_id])
    @category = @product.category
    @comment = @product.comments.find(params[:id])
    @comments = @product.comments

      if @comment.destroy
        flash[:notice] = "Comment was removed"
      else
        flash[:error] = "Comment was not deleted. Try again."
      end
    respond_with(@comment) do |format|
       format.html { redirect_to [@product.category, @product] }
    end

  end

  private

     def load_activities
      if current_user
        @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
      end
    end

  def comment_params
    params.require(:comment).permit(:body)
  end

end

