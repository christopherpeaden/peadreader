RSpec.describe 'Site layout link' do
  
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

end
