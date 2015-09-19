require 'rails_helper'

RSpec.describe "UserSignIn", type: :request do

  let(:user) { create(:user) }

  describe "sign in" do

    before(:each) do
      visit "/users/sign_in"
      expect(page).to have_selector("h2", text: "Log in")
    end

    context "successful" do

      it "brings user to dashboard" do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Log in"
        expect(page).to have_content("Signed in successfully")
      end

      describe "followed by signout" do

        it "brings user to home page" do
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
          expect(page).to have_content("Signed in successfully")
          click_link "Sign Out"
          expect(page).to have_content("Signed out")
        end
      end

    end

    context "failure" do

      it "rejects invalid password" do
        fill_in "Email", with: user.email
        fill_in "Password", with: "zippydoodah"
        click_button "Log in"
        expect(page).to have_content("Invalid email or password")
      end
    end
  end
end
