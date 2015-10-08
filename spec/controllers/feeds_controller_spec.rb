require 'rails_helper'

RSpec.describe FeedsController do

  let(:user) { create(:user) }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in(user)
  end

  describe "GET #new" do
    it "renders the new feed form" do
      get :new
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end
    
  describe "POST #create" do
    context "with valid attributes" do
      it "creates a feed" do
        post :create, feed: attributes_for(:feed)
        expect(Feed.count).to eq(1)
      end

      it 'redirects to the "show" action for the new feed' do
        post :create, feed: attributes_for(:feed)
        expect(response).to redirect_to Feed.first
      end
    end

    context 'with invalid attributes' do
      it 'does not create the feed' do
        post :create, feed: attributes_for(:feed, title: nil)
        expect(Feed.count).to eq(0)
      end

      it 're-renders the "new" view' do
        post :create, feed: attributes_for(:feed, title: nil)
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      feed = create(:feed)
      get :show, id: feed
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe "GET #edit" do
    it "displays the edit form" do
      feed = create(:feed)
      get :edit, id: feed
      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    it "edits the feed" do
      feed = create(:feed)
      put :update, id: feed, feed: attributes_for(:feed)
      expect(Feed.first.title).to_not eq feed.title
    end
  end

  describe "DELETE #destroy" do
    it "deletes the feed" do
      feed = create(:feed)
      delete :destroy, id: feed
      expect(Feed.count).to eq(0)
    end
  end
end
