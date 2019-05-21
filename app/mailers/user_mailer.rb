class UserMailer < ApplicationMailer
    def daily_products(user, products)
        @user = user
        @products = products
        mail(to: @user.email, subject: "Los productos Top de ayer :D")
    end
end
