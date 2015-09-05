require 'rails_helper'

RSpec.describe "UserSignUp", type: :request do

  describe "user signing up" do
    
    it "is a successful sign up" do
      visit '/users/sign_up' 
      expect(page).to have_selector "h2", text: "Sign up"
    end

  end

end
