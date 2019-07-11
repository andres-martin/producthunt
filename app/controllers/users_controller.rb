class UsersController < ApplicationController
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if @user.save 
            #UserMailer.account_activation(@user).deliver_now
            @user.send_activation_email
      #flash[:info] = "Please check your email to activate your account."
            flash[:notice] = "Please check your email to activate your account."
            redirect_to root_path 
        else 
            render :new
        end
    end
    private
        def user_params
            params.require(:user).permit(:email, :password, :name, :twitter_handle)
        end
        
end
