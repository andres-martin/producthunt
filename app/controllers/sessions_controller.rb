class SessionsController < ApplicationController
  before_action :private_access, only: [:destroy]
  before_action :public_access, except: [:destroy]
  
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in(user)
       if user.activated?
        sign_in(user)
        params[:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        #flash[:warning] = message
        flash[:notice] = message
        redirect_to root_path
      end
      ### not working
      # params[:session][:remember_me] == '1' ? user.remember : user.forget
      
    else 
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end  
  end

  def destroy
    sign_out 
    redirect_to root_path
  end
  
  
end
