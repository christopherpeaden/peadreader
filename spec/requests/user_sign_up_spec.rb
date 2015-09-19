require 'rails_helper'

RSpec.describe "UserSignUp", type: :request do

  let(:user) { build(:user) }

  describe "sign up" do

    before(:each)  do
      visit "/users/sign_up"
      expect(page).to have_selector("h2", text: "Sign up")
    end

    context "sucess" do
    
      it "allows access to home page" do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        fill_in "Password confirmation", with: user.password_confirmation

        click_button "Sign up"
        expect(page).to have_content("successfully")
      end
    end

    context "failure" do
      
      it "rejects blank email" do
        fill_in "Email", with: " "
        fill_in "Password", with: user.password
        fill_in "Password confirmation", with: user.password_confirmation

        click_button "Sign up"
        expect(page).to have_content("user from being saved")
      end

      it "rejects blank password" do
        fill_in "Email", with: user.email
        fill_in "Password", with: " "
        fill_in "Password confirmation", with: user.password_confirmation

        click_button "Sign up"
        expect(page).to have_content("user from being saved")
      end
      
      it "rejects blank password confirmation" do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        fill_in "Password confirmation", with: " "

        click_button "Sign up"
        expect(page).to have_content("user from being saved")
      end

      it "rejects difference in password from confirmation" do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password + "typo"
        fill_in "Password confirmation", with: user.password_confirmation

        click_button "Sign up"
        expect(page).to have_content("user from being saved")
      end
        
    end
  end

end
