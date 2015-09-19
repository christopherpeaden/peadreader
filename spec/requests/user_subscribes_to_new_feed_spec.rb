RSpec.describe "User subscribes to new feed", type: :request do

  let(:feed) { build(:feed) }

  context "successfully" do
    
    it "saves feed to database" do
      visit "/users/sign_in"
      expect(page).to have_selector("h2", "Log in")
      fill_in "Email", with: feed.user.email
      fill_in "Password", with: feed.user.password
      click_button "Log in"
      expect(page).to have_content("Signed in successfully")

      expect(Feed.count).to be 0
      visit "/feeds/new"
      fill_in "Title", with: feed.title
      fill_in "Url", with: feed.url
      click_button "Submit"
      expect(Feed.count).to be 1
    end
  end

  context "failure" do

    it "rejects invalid input" do
      visit "/users/sign_in"
      expect(page).to have_selector("h2", "Log in")
      fill_in "Email", with: feed.user.email
      fill_in "Password", with: feed.user.password
      click_button "Log in"
      expect(page).to have_content("Signed in successfully")

      expect(Feed.count).to be 0
      visit "/feeds/new"
      fill_in "Title", with: " "
      fill_in "Url", with: feed.url
      click_button "Submit"
      expect(Feed.count).to be 0
      expect(page).to have_content "error"
    end
  end
end
