require 'rails_helper'

RSpec.describe 'Site layout links' do
  let(:user) { create(:user) }

  before(:each) do
    sign_in_valid_user(user)
  end

  it 'has header links for navigation' do
    click_link 'Dashboard'
    expect(page).to have_selector('div#items')
    click_link 'Refresh'
    expect(page).to have_selector('div#items')
    click_link 'Categories'
    expect(page).to have_selector('h1', text: 'Categories')
    click_link 'Subscribe'
    expect(page).to have_selector('h1', text: 'Start a new feed')
    click_link 'Sign Out'
    expect(page).to have_selector('p', text: 'Signed out successfully')
  end

  describe "conditional site links" do
    
    let(:feed) { create(:feed, user: user) }

    it "navigates to respective category page" do
      category = create(:category, user: user)
      visit '/'
      click_link category.title
      expect(page).to have_selector('div#items')
    end

    it "navigates to respective feed page" do
      3.times { create(:item, feed: feed) }
      visit '/'
      expect(page).to have_selector('a', text: Item.first.title)
      expect(page).to have_selector('a', text: Item.second.title)
      expect(page).to have_selector('a', text: Item.third.title)
      expect(page).to have_selector('a', text: "More")
    end

    it "uses pagination" do
      31.times { create(:item, feed: feed) }
      visit '/'
      expect(page).to_not have_selector('a', text: Item.first.title)
      expect(page).to have_selector('a', text: Item.second.title)
      expect(page).to have_selector('a', text: Item.third.title)
      expect(page).to have_selector('div.pagination')
      click_link("2", match: :first)
      expect(page).to have_selector('a', text: Item.first.title)
      expect(page).to_not have_selector('a', text: Item.second.title)
      expect(page).to_not have_selector('a', text: Item.third.title)
    end
  end
end
