require 'rails_helper'

RSpec.describe "User sign in" do
  let(:user) { create(:user) }

  before(:example) do
    visit "/users/sign_in"
    expect(page).to have_selector("h1", text: "Sign In")
  end

  context "success" do

    before(:example) do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign In"
    end

    it "allows access to dashboard" do
      expect(page).to have_content("Signed in successfully")
    end

    describe "followed by signout" do

      it "directs user to home page" do
        click_link "Sign Out"
        expect(page).to have_content("Signed out")
      end
    end
  end

  context "failure" do
    it "rejects blank values" do
      fill_in "Email", with: ""
      fill_in "Password", with: ""
      click_button "Sign In"
      expect(page).to have_content("Invalid Email or password.")
    end

    it "rejects invalid password" do
      fill_in "Email", with: user.email
      fill_in "Password", with: "zippydeedoodah"
      click_button "Sign In"
      expect(page).to have_content("Invalid Email or password.")
    end
  end
end
