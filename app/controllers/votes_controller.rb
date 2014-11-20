class VotesController < ApplicationController
  respond_to :html, :js

  before_action :load_post_and_vote
  after_action :update_product

  def up_vote
  if current_user
    if current_user.id == 1 || current_user.id == 2 || current_user.id == 3 || current_user.id == 4
        @product.up_vote!(current_user)
          respond_with(@product) do |format|
          format.html { redirect_to :back}
          end
        elsif
         @product.already_up_voted_by_user?(current_user)
          @product.already_upvote(current_user)
          respond_with(@product) do |format|
          format.html { redirect_to :back}
          end
        elsif @product.already_down_voted_by_user?(current_user)
          @product.already_downvote(current_user)
          @product.up_vote!(current_user)
          respond_with(@product) do |format|
          format.html { redirect_to :back}
          end
        else
          @product.up_vote!(current_user)
          respond_with(@product) do |format|
          format.html { redirect_to :back}
          end
        end
      else
        flash[:error] = "You must sign in"
        redirect_to new_user_session_path
      end
  end

  def down_vote
    if current_user
      if current_user.id == 1 || current_user.id == 2 || current_user.id == 3 || current_user.id == 4
        @product.down_vote!(current_user)
          respond_with(@product) do |format|
          format.html { redirect_to :back}
          end
      elsif @product.already_down_voted_by_user?(current_user)
         @product.already_downvote(current_user)
         respond_with(@product) do |format|
        format.html { redirect_to :back}
        end
      elsif @product.already_up_voted_by_user?(current_user)
        @product.already_upvote(current_user)
        @product.down_vote!(current_user)
        respond_with(@product) do |format|
        format.html { redirect_to :back}
        end
      else
        @product.down_vote!(current_user)
        respond_with(@product) do |format|
        format.html { redirect_to :back}
        end
      end
      else
      flash[:error] = "You must sign in"
       redirect_to new_user_session_path
    end
  end



  private

    def load_post_and_vote
      @product = Product.friendly.find(params[:product_id])
      @category = @product.category
    end

    def update_product
      @product.update_rank
    end

end