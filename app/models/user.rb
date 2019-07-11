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
#  remember_digest :string
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
    before_save   :downcase_email
    before_create :create_activation_digest
      # Returns the hash digest of the given string. #MAY BE OPTIONAL # from advanced login chapter 9
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
     # Returns a random token., for secure password!
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  ###########################
# Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  # Returns true if the given token matches the digest.
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")  
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
# Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end
  


  ### recover password email section ########################
  # Sets the password reset attributes.
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end
# Sends password reset email.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    

     # Activates an account.
    def activate
      update_attribute(:activated,    true)
      update_attribute(:activated_at, Time.zone.now)
    end

    # Sends activation email.
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
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
