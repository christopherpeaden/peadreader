require 'rails_helper'

RSpec.describe OPMLImporter do
  let(:user) { create(:user) }

  before(:each) do
    sign_in_valid_user(user)
    visit '/feeds/new'
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
