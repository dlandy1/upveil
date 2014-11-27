class ActivitiesController < ApplicationController
  def index
    @cactivities = PublicActivity::Activity.where(recipient_id: current_user.id, owner_type: "User").order("created_at desc")
     @activities = PublicActivity::Activity.where(read: false).where(recipient_id: current_user.id, owner_type: "User").order("created_at desc").limit(80)
  end
end
