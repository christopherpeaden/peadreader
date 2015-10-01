RSpec.describe "User subscribes to new feed" do

  let(:feed) { build(:feed) }

  before(:each) do
    visit "/users/sign_in"
    fill_in "Email", with: feed.user.email
    fill_in "Password", with: feed.user.password
    click_button "Log in"
    visit "/feeds/new"
    expect(Feed.count).to be 0
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
end
