class ApplicationController < ActionController::Base
  respond_to :html, :js
  include PublicActivity::StoreController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def notifications
    if current_user
      @activities = PublicActivity::Activity.where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
    end
  end

  def read_all_notification
   PublicActivity::Activity.where(recipient_id: current_user.id).update_all(:read => true)
   respond_with(@activities) do |format|
          format.html { redirect_to :back}
    end
  end 
  
  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  def holidays
      @products = Product.where(holiday: true).order('rank DESC').page(params[:page]).per(10)
       @leaders =  HIGHSCORE_LB.leaders(1)
        if current_user
      @activities = PublicActivity::Activity.where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
    end
  end

  def holidays_newest
      @products = Product.where(holiday: true).order('created_at DESC').page(params[:page]).per(10)
       @leaders =  HIGHSCORE_LB.leaders(1)
        if current_user
      @activities = PublicActivity::Activity.where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
    end
  end
end
