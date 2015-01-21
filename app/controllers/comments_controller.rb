class CommentsController < ApplicationController
  respond_to :html, :js

  def create
     @product = Product.friendly.find(params[:product_id])
    @comments = @product.comments

    @commentr = current_user.comments.new( comment_params )
    @comment = Comment.new

    if current_user
      if @commentr.save
        flash[:notice] = "Comment was created successfully."
      else
        flash[:error] = "Error creating comment."
      end
    end

    respond_with(@commentr) do |format|
      format.html { redirect_to [@product.category, @product] }
    end
  end

  def destroy
    @product = Product.friendly.find(params[:id])
    @category = @product.category
    @comment = @product.comments.find(params[:id])

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

  def comment_params
    params.require(:comment).permit(:body)
  end

end

