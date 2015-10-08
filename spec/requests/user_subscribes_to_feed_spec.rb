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

  describe "import opml file" do
    context "successful" do
      it "imports all feeds" do
        expect(page).to have_content "Start"
        fill_in "Title", with: "a"
        fill_in "Url", with: "a"
        page.attach_file('File', Rails.root + 'spec/support/sample_opml')
        click_button "Submit"
        expect(Feed.first.title).to eq 'RSDBrad'
      end
    end
  end
end
