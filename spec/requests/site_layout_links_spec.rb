require 'rails_helper'

RSpec.describe 'Site layout' do
  let(:user) { create(:user) }

  before(:each) do
    sign_in_valid_user(user)
  end

  describe "navbar link" do
    it 'routes to respective page' do
      click_link 'Home'
      expect(page).to have_selector('div#items')
      click_link 'Create new feed'
      expect(page).to have_selector('h1', text: 'Subscribe to new feed')
      click_link 'Show all feeds'
      expect(page).to have_selector('h1', text: 'All Feeds')
      click_link 'Import OPML File'
      expect(page).to have_selector('label', text: 'Import OPML File')
      click_link 'Favorites'
      expect(page).to have_selector('h1', text: 'Favorites')
      click_link 'Saved for later'
      expect(page).to have_selector('h1', text: 'Saved for later')
      click_link 'Edit Profile'
      expect(page).to have_selector('h1', text: 'Edit User')
      click_link 'Sign Out'
      expect(page).to have_selector('div.alert', text: 'Signed out successfully.')
    end
  end

  describe "conditional link" do
    let(:feed) { create(:feed, user: user) }

    it "navigates to respective category page" do
      category = create(:category, user: user)
      visit '/'
      click_link category.title
      expect(page).to have_selector('h1', text: category.title)
    end


    it "displays category header link" do
      category = create(:category, user: user)
      visit '/'
      click_link 'Categories'
      expect(page).to have_selector('h1', text: 'Categories')
    end


    it "navigates to respective feed page" do
      category = create(:category, user: user)
      feed.update(category_ids: category.id)
      visit '/'
      click_link feed.title
      expect(page).to have_selector('h1', text: feed.title)
    end

    it "displays links to item titles" do
      3.times { create(:item, feed: feed, user: user) }
      visit '/'
      expect(page).to have_selector('a', text: Item.first.title)
      expect(page).to have_selector('a', text: Item.second.title)
      expect(page).to have_selector('a', text: Item.third.title)
      expect(page).to have_selector('a', text: "More")
      expect(page).to have_selector('a', text: "Add to favorites")
      expect(page).to have_selector('a', text: "Save for later")
    end

    it "paginates results" do
      31.times { create(:item, feed: feed, user: user) }
      visit '/'
      expect(page).to_not have_selector('a', text: Item.first.title)
      expect(page).to have_selector('a', text: Item.second.title)
      expect(page).to have_selector('a', text: Item.third.title)
      expect(page).to have_selector('ul.pagination')
      click_link("2", match: :first)
      expect(page).to have_selector('a', text: Item.first.title)
      expect(page).to_not have_selector('a', text: Item.second.title)
      expect(page).to_not have_selector('a', text: Item.third.title)
    end
  end
end
