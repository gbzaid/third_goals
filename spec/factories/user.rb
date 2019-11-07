require 'faker'
FactoryBot.define do
    factory :user do 
        username {Faker::Name.name}
        password {Faker::Name.name}
        # refactor this, factory bot shouldn't be doing this
        password_digest { BCrypt::Password.create(password)}
        session_token { User.generate_session_token}
    end
end