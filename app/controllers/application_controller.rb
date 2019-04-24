class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def sign_in(user)
        cookies.permanent.signed[:user_id] = user.id
        @current_user = user
    end

    def sign_out
        cookies.delete(:user_id)
        @current_user = nil
    end
    
    private
        def signed_in?
            !current_user.nil?
        end
        helper_method :signed_in?

        def current_user
            @current_user ||= User.find(cookies.signed[:user_id]) if cookies.signed[:user_id]
            rescue ActiveRecord::RecordNotFound
        end
        helper_method :current_user    
end
