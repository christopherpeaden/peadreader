require "rails_helper"

RSpec.describe "User managing category" do
  let(:category) { build(:category) }
  let(:user) { create(:user) }

  before(:each) do
    sign_in_valid_user(user)
    visit '/categories/new'
  end

  describe "creation" do

    context "successful" do
      it "saves to database" do
        fill_in "Title", with: category.title
        click_button "Submit"
        expect(page).to have_selector('h1', text: category.title)
        expect(Category.first.title).to eq category.title
      end
    end

    context "failure" do
      it "does not save to database" do
        fill_in "Title", with: "" 
        click_button "Submit"
        expect(Category.count).to be 0
        expect(page).to have_content "problem"
      end
    end
  end

  describe "editing" do
    it "changes and saves title" do
      fill_in "Title", with: category.title
      click_button "Submit"
      expect(page).to have_selector('h1', text: category.title)
      expect(Category.first.title).to eq category.title
      click_link "Edit"
      new_title = "test title"
      fill_in "Title", with: new_title
      click_button "Submit"
      expect(Category.first.title).to eq new_title 
    end
  end

  describe "deleting" do
    it "removes from database" do
      fill_in "Title", with: category.title
      click_button "Submit"
      expect(page).to have_selector('h1', text: category.title)
      expect(Category.first.title).to eq category.title
      click_link "Delete"
      expect(Category.first).to be_nil
    end
  end
end
