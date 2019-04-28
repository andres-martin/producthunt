class VotesController < ApplicationController
    # agrega beforeaction private access para redirecionar users no logged in
    before_action :private_access
    def create
        product = Product.find(params[:product_id])
        product.votes.create(user: current_user)

        redirect_to root_path
    end
        
    def destroy
        product = Product.find(params[:product_id])
        product.votes.where(user: current_user).take.try(:destroy)

        redirect_to root_path
    end
end
