class AccountActivationsController < ApplicationController
    def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            #user.update_attribute(:activated,    true)
            #user.update_attribute(:activated_at, Time.zone.now)
            user.activate
            sign_in(user)
            #flash[:success] = "Account activated!"
            flash[:notice] = "Account activated!"
            redirect_to user
        else
            #flash[:danger] = "Invalid activation link"
            flash[:notice] = "Invalid activation link"
            redirect_to root_path
        end
    end
end
