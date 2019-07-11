class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def sign_in(user)
        cookies.permanent.signed[:user_id] = user.id
        @current_user = user
    end

    def sign_out
        current_user.forget
        cookies.delete(:user_id)
        @current_user = nil
    end
    
    private
        def signed_in?
            !current_user.nil?
        end
        helper_method :signed_in?

        # original code current_user method
        def current_user
            @current_user ||= User.find(cookies.signed[:user_id]) if cookies.signed[:user_id]
            rescue ActiveRecord::RecordNotFound
        ## experimental validation !!!
            if user && user.authenticated?(:remember, cookies[:remember_token])
                sign_in(user)
                @current_user = user
            end
        end
        
        ##code from advanced login chapter 9.9
    #   def current_user
    #       if (user_id = session[:user_id])
    #           @current_user ||= User.find_by(id: user_id)
    #       elsif (user_id = cookies.signed[:user_id])
    #           user = User.find_by(id: user_id)
    #           if user && user.authenticated?(cookies[:remember_token])
    #               sign_in(user)
    #               @current_user = user
    #           end
    #       end
    #   end  
    
      helper_method :current_user  

        def private_access
            redirect_to :login unless signed_in?
        end

        def public_access
            redirect_to root_path if signed_in?
        end
        
end
