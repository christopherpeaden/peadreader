require 'rails_helper'

RSpec.describe "UserSignUp", type: :request do


  before(:each) do
    @user = build(:user)
  end

  describe "user signing up" do
    
    it "is a successful sign up" do
      visit "/users/sign_up" 
      expect(page).to have_selector("h2", text: "Sign up")
      expect { post "/users", params: { email: @user.email, password: @user.password, password_confirmation: @user.password_confirmation }.to change(User.count).by 1 }
    end

  end

end
