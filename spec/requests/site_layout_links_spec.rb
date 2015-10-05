RSpec.describe 'Site link' do
  
  let(:user) { create(:user) }

  before(:each) do
    sign_in_valid_user(user)
  end

  it 'navigates to respective page' do
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

  describe "creates additional links if neccesary" do

    it "navigates to respective category page" do
      category = create(:category, user: user)
      visit '/'
      click_link category.title
      expect(page).to have_selector('div#items')
    end

    it "navigates to respective feed page" do
      feed = Feedjira::Feed.parse("/home/peady/Development/rails/projects/feed_reader/spec/support/sample_xml")
      expect(feed).to be_truthy
    end
  end
end
