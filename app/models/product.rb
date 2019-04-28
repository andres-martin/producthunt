# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string
#  url         :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

class Product < ApplicationRecord
    belongs_to :user
    has_many :comments
    has_many :votes

    has_one_attached :image
    
    validates :name, presence: true
    validates :url, presence: true
    validate :image_format

    def image_format
        if image.attached?
            if image.blob.byte_size > 1000000
                image.purge_later
                errors[:base] << 'Too big'
            elsif !image.blob.content_type.starts_with?('image/')
                image.purge_later
                errors[:base] << 'Wrong format'
            end
        end
    end

    def voted_by?(user)
        votes.exists?(user: user)
    end
    
end
