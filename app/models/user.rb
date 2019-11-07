class User < ApplicationRecord
    
    validates :username, :password_digest, :password, presence: true
    validates :username, uniqueness: true
    validates :password, length: { minimum: 6}, allow_nil: true

    
    attr_reader :password

    def password=(password)
        @password = password
    end

    def self.find_by_credentials(username, password)
        # debugger
        user = User.find_by(username: username)
        return nil if user.nil?
        if user.is_password?(password)
            return user
        else  
            return nil 
        end
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def reset_session_token!
        self.session_token = self.class.generate_session_token
        self.save!
        self.session_token
    end

end