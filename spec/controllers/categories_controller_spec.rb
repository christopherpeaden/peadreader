require 'rails_helper'

RSpec.describe CategoriesController do

  let(:user) { create(:user) }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in(user)
  end

  describe "GET #new" do
    it "renders the new category form" do
      get :new
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end
    
  describe "POST #create" do
    context "valid" do
      it "creates a category" do
        post :create, category: attributes_for(:category)
        expect(Category.count).to eq(1)
      end

      it 'redirects to the "show" action for the new category' do
        post :create, category: attributes_for(:category)
        expect(response).to redirect_to Category.first
      end
    end

    context 'with invalid attributes' do
      it 'does not create the category' do
        post :create, category: attributes_for(:category, title: nil)
        expect(Category.count).to eq(0)
      end

      it 're-renders the "new" view' do
        post :create, category: attributes_for(:category, title: nil)
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      category = create(:category)
      get :show, id: category
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
      category = create(:category)
      get :edit, id: category
      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    it "edits the category" do
      category = create(:category)
      put :update, id: category, category: attributes_for(:category)
      expect(Category.first.title).to_not eq category.title
    end
  end

  describe "DELETE #destroy" do
    it "deletes the category" do
      category = create(:category)
      delete :destroy, id: category
      expect(Category.count).to eq(0)
    end
  end
end
