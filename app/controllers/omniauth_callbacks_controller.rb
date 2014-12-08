class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.friendly.find_for_oauth(env["omniauth.auth"], current_user) 
        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
           @user.update_attributes(image: @user.identity.smallimage)
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          current_user.update_attributes(image: current_user.identity.smallimage)
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:facebook].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end
end