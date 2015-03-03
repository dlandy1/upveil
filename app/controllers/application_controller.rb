class ApplicationController < ActionController::Base
  respond_to :html, :js
  before_filter :parent
  include PublicActivity::StoreController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def notifications
    if current_user
      @activities = PublicActivity::Activity.where(recipient_id: current_user.id, owner_type: "User").where(read: false).order("created_at desc")
    end
  end

  def read_all_notification
   PublicActivity::Activity.where(recipient_id: current_user.id).update_all(read: true)
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

   private   

  def parent
  if request.original_url.index("categories")
    yourl = "#{request.fullpath.gsub('categories','').gsub('/', '').gsub('newest', '').gsub('female', '').gsub('male', '').gsub('_', '')}"
    if yourl == "tech" || yourl == "vehicle" || yourl == "sport" || yourl == "decor" || yourl == "food" || yourl.index("/")
      console.log "hello"
    else
    if Category.find_by_slug(yourl)
    @category = Category.find_by_slug(yourl)
     @variable = Category.find(1).subcategories.collect(&:slug).include?(yourl) || Category.find(1).subcategories.include?(@category.parent_category)
     @variablea = Category.find(2).subcategories.collect(&:slug).include?(yourl) || Category.find(2).subcategories.include?(@category.parent_category) || Category.find(2) == @category
     @variable_b = Category.find(3).subcategories.collect(&:slug).include?( yourl) || Category.find(3).subcategories.include?(@category.parent_category)
     @variable_c = Category.find(4).subcategories.collect(&:slug).include?( yourl) || Category.find(4).subcategories.include?(@category.parent_category)
     @variable_d = Category.find(5).subcategories.collect(&:slug).include?( yourl) || Category.find(5).subcategories.include?(@category.parent_category)
     @variable_e = Category.find(6).subcategories.collect(&:slug).include?( yourl) || Category.find(6).subcategories.include?(@category.parent_category)
   console.log   @category
  end
  end

  end
end

  
end
