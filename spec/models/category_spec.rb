require 'rails_helper'

RSpec.describe Category do

  subject { build(:category) }
  let(:category) { subject }
  let(:user) { create(:user) }
  let(:user_2) { create(:user, email: "snorlax123@example.com", password: "12345678", password_confirmation: "12345678") }

  describe "messages" do
    it {should respond_to(:id) }
    it {should respond_to(:title) }
  end

  describe "associations" do
    it { should respond_to(:user) }
    it { should respond_to(:feeds) }
    it { should respond_to(:categorizations) }
  end

  describe "validations" do
    it { should be_valid }

    it "rejects blank title" do
      category.title = ""
      expect(category).to be_invalid
    end

    it "rejects duplicate title from same user" do
      category.user_id = user.id
      category.save
      dup_category = build(:category, title: category.title, user: user)
      expect(dup_category.save).to be false
    end

    it "accepts duplicate title from different user" do
      category.user_id = user.id
      category.save
      dup_category = build(:category, title: category.title, user: user_2)
      expect(dup_category.save).to be true
    end
  end
end
