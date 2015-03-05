class CommentsController < ApplicationController
  respond_to :html, :js
  before_action :load_activities

  def create
     @product = Product.friendly.find(params[:product_id])
     @category= Category.friendly.find(params[:category_id])
    @comments = @product.comments

    @comment = current_user.comments.new( comment_params )
     @comment.product = @product
    @new_comment = Comment.new

    if current_user
      if @comment.save
        if @comment.parent_comment
          @comment.create_activity :reply, owner: current_user,  recipient: @comment.user
        end
          if @product.user != current_user
        @product.create_activity :comment, owner: current_user,  recipient: @product.user
      end
      else
        flash[:error] = "Error creating comment."
      end
    end

    respond_with(@comment) do |format|
      format.html { redirect_to [@product.category, @product] }
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @product = @comment.product
    @category= @product.category
  end

  def reply
    @comment = Comment.find(params[:comment_id])
    @new_comment = @comment.subcomments.new
    @product= Product.friendly.find(params[:product_id])
    @category= @product.category
     respond_with(@comment) do |format|
       format.html { redirect_to [@category, @product] }
    end
  end

   def cancel
    @comment = Comment.find(params[:comment_id])
    @product= Product.friendly.find(params[:product_id])
    @category= @product.category
     respond_with(@comment) do |format|
       format.html { redirect_to [@category, @product] }
    end
  end

  def update
         @comment = Comment.find(params[:id])
         @new_comment = @comment
         @product = @comment.product
         @category= @product.category
          if @comment.update_attributes(comment_params)
            redirect_to [@category, @product]
          else
           render :action => "edit" 
          end
      end

  def destroy
    @category = Category.friendly.find(params[:category_id])
    @product = @category.products.friendly.find(params[:product_id])
    @comment = @product.comments.find(params[:id])
     if current_user
        if @comment.destroy
          PublicActivity::Activity.where(trackable_id: @product.id).where(owner_id: @comment.user.id).each do |p|
            p.last.destroy
          end
        else
          flash[:error] = "Comment was not deleted. Try again."
        end
      end
    respond_with(@comment) do |format|
       format.html { redirect_to [@category, @product] }
    end

  end

  private

     def load_activities
      if current_user
        @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
      end
    end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

end

