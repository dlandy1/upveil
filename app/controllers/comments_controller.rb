class CommentsController < ApplicationController
 def create
    @product = Product.find(params[:post_id])
    @comments = @product.comments

    @comment = current_user.comments.new( comment_params )
    @comment.product = @product
    @new_comment = Comment.new

    authorize @comment

    if @comment.save
      flash[:notice] = "Comment was created successfully."
    else
      flash[:error] = "Error creating comment. It must be more than 5 characters. Please try again."
    end

    respond_with(@comment) do |format|
      format.html { redirect_to [@product.category, @product] }
    end
  end

 def destroy
    @product = Product.find(params[:post_id])
    @category = @product.category
    @comment = @product.comments.find(params[:id])

    authorize @comment
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
