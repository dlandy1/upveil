class VotesController < ApplicationController

  before_action :load_post_and_vote

  def up_vote
    if @product.already_up_voted_by_user?(current_user)
       @product.remove_up_vote!(current_user)
       @product.category.increase_grade(current_user, -3)
      redirect_to :back
    elsif @product.already_down_voted_by_user?(current_user)
      @product.remove_down_vote!(current_user)
      @product.up_vote!(current_user)
      @product.category.increase_grade(current_user, 2)
      redirect_to :back
    else
      @product.up_vote!(current_user)
      @product.category.increase_grade(current_user, 3)
      redirect_to :back
    end
  end

  def down_vote
    if @product.already_down_voted_by_user?(current_user)
      @product.remove_down_vote!(current_user)
      @product.category.increase_grade(current_user, -1)
      redirect_to :back
    elsif @product.already_up_voted_by_user?(current_user)
      @product.remove_up_vote!(current_user)
      @product.down_vote!(current_user)
      @product.category.increase_grade(current_user, -2)
      redirect_to :back
    else
      @product.down_vote!(current_user)
      @product.category.increase_grade(current_user, 1)
      redirect_to :back
    end
  end



  private

    def load_post_and_vote
      @product = Product.find(params[:product_id])
      @category = @product.category
    end

end