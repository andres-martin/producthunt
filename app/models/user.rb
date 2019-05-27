# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(100)
#  password_digest :string
#  name            :string(100)
#  twitter_handle  :string(50)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  reset_digest    :string
#  reset_sent_at   :datetime
#

class User < ApplicationRecord
    has_secure_password validations: false
    
    has_many :products
    has_many :comments
    has_many :votes

    validates :email, uniqueness: true, format: /@/
    validates :password, presence: true, on: :create
    validates :password, length: {minimum:6, maximum:20}, allow_nil: true 
    validates :name, presence: true

    attr_accessor :remember_token, :activation_token, :reset_token

    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    
    private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
