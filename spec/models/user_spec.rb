require 'rails_helper'
require 'faker'


RSpec.describe User, type: :model do 
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_length_of(:password).is_at_least(6) }
    
    describe "uniqueness" do
        subject {FactoryBot.create(:user)}
        it { should validate_uniqueness_of(:username) }
    end

    describe "self.find_by_credentials" do
        let!(:my_guy) { FactoryBot.create(:user)}
        it "should return the user if found" do
            expect(User.find_by_credentials(my_guy.username, my_guy.password)).to be_a(User)
        end

        it "should return nil if not found" do
            expect(User.find_by_credentials("hank", "asdfhkl")).to be(nil)
        end

    end

    describe "#is_password?" do 
        let!(:my_guy) { FactoryBot.create(:user)}
        it "should return true if the password is correct" do
            expect(my_guy.is_password?(my_guy.password)).to be(true)
        end

        it "should return false if the password is incorrect" do
            expect(my_guy.is_password?("awefawef")).to be(false)
        end
    end

    describe "::generate_session_token" do
        let!(:my_guy) { FactoryBot.create(:user)}
        it "should generate a session token" do
            expect(User.generate_session_token).not_to be(nil)
        end
    end

    describe "#password=" do
        let(:my_guy) { FactoryBot.build(:user, password: "hi")}
        it "should only accept passwords with a length of at least 6" do
            expect(my_guy.valid?).to be(false)
        end
    end

    describe "#reset_session_token!" do
        let!(:my_guy) { FactoryBot.create(:user)}
        it "should change the session token" do
            old_token = my_guy.session_token
            expect(my_guy.reset_session_token!).not_to eq(old_token)
        end
    end

    describe "#ensure_session_token" do 
        let!(:my_guy) { FactoryBot.create(:user)}
        it "should validate that the user has a token" do
            expect(my_guy.session_token).not_to be(nil) 
        end
    end
end