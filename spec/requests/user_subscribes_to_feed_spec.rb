require 'rails_helper'

RSpec.describe "User subscribes to feed" do
  let(:feed) { build(:feed) }
  let(:user) { create(:user) }

  before(:each) do
    sign_in_valid_user(user)
    visit '/feeds/new'
  end

  context "successful" do
    it "saves feed to database" do
      fill_in "Title", with: feed.title
      fill_in "Url", with: feed.url
      click_button "Submit"
      expect(page).to have_selector('h1', text: feed.title)
      expect(Feed.first.title).to eq feed.title
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

  describe "edit feed" do
    it "changes and saves feed data" do
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

  describe "delete feed" do
    it "removes feed from database" do
      fill_in "Title", with: feed.title
      fill_in "Url", with: feed.url
      click_button "Submit"
      expect(page).to have_selector('h1', text: feed.title)
      expect(Feed.first.title).to eq feed.title
      click_link "Delete"
      expect(Feed.first).to be_nil
    end
  end

  describe "import opml file" do
    context "successful" do
      it "imports all feeds" do
        visit '/new_opml_import'
        expect(page).to have_selector('label', text: "Import OPML File")
        page.attach_file('file', Rails.root + 'spec/support/sample_opml')
        click_button "Submit"
        expect(page).to have_selector("div", text: "Successfully imported OPML file")
        expect(Feed.first.title).to eq 'RSDBrad'
      end
    end
  end
end
