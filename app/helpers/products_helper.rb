module ProductsHelper
    def form_title
        @product.new_record? ? "Publish Product" : "Modify Product"
    end

    def header_style
        if @product.image.attached?
            %{ style="background-image: linear-gradient( rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5) ), url('#{rails_blob_url(@product.image)}'); background-size: cover; background-position: center;" }.html_safe
        else
            ""
        end
    end
end
