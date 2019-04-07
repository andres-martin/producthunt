module ProductsHelper
    def form_title
        @product.new_record? ? "Publish Product" : "Modify Product"
    end
end
