require 'rails_helper'

RSpec.describe "User managing feed" do
  let(:feed) { build(:feed) }
  let(:user) { create(:user) }

  before(:each) do
    sign_in_valid_user(user)
    visit '/feeds/new'
  end

  context "successful" do
    let(:user_2) { create(:user, email: "snorlax123@example.com", password: "12345678", password_confirmation: "12345678") }
    it "saves feed to database" do
      fill_in "Title", with: feed.title
      fill_in "Url", with: feed.url
      click_button "Submit"
      expect(page).to have_selector('h1', text: feed.title)
      expect(Feed.first.title).to eq feed.title
      click_link 'Sign Out'

      sign_in_valid_user(user_2)
      visit '/feeds/new'
      fill_in "Title", with: feed.title
      fill_in "Url", with: feed.url
      click_button "Submit"
      expect(page).to have_selector('h1', text: feed.title)
      expect(Feed.second.title).to eq Feed.first.title 
    end
  end

  context "failure" do
    it "rejects blank values" do
      fill_in "Title", with: ""
      fill_in "Url", with: feed.url
      click_button "Submit"
      expect(Feed.count).to be 0
      expect(page).to have_content "error"
    end
  end

  describe "editing" do
    it "changes and saves new data" do
      fill_in "Title", with: feed.title
      fill_in "Url", with: feed.url
      click_button "Submit"
      expect(page).to have_selector('h1', text: feed.title)
      expect(Feed.first.title).to eq feed.title
      click_link "Edit"
      new_title = "test title"
      fill_in "Title", with: new_title
      click_button "Submit"
      expect(Feed.first.title).to eq new_title 
    end
  end

  describe "deleting" do
    it "removes from database" do
      fill_in "Title", with: feed.title
      fill_in "Url", with: feed.url
      click_button "Submit"
      expect(page).to have_selector('h1', text: feed.title)
      expect(Feed.first.title).to eq feed.title
      click_link "Delete"
      expect(Feed.first).to be_nil
    end
  end
end
