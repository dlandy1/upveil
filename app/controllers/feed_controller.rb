class FeedController < ApplicationController
before_action :load_activities

  def show
    if current_user
      @products = Kaminari.paginate_array(current_user.food.sort_by(&:created_at).reverse).page(params[:page]).per(10)
      @leaders =  HIGHSCORE_LB.leaders(1)
    else
      redirect_to new_user_session_path
    end
  end

private

    def load_activities
      if current_user
        @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
      end
    end
end