require 'rails_helper'

RSpec.describe Item do

  subject { build(:item, user: user) }
  let(:item) { subject }
  let(:user) { create(:user) }
  let(:user_2) { create(:user, email: "snorlax123@example.com", password: "12345678", password_confirmation: "12345678") }

  describe "messages" do
    it { should respond_to(:id) }
    it { should respond_to(:title) }
  end

  describe "associations" do
    it { should respond_to(:feed) }
  end

  describe "validations" do
    it { should be_valid }

    it "rejects blank title" do
      item.title = ""
      expect(item).to be_invalid
    end

    it "accepts duplicate title from different users" do
      item.user_id = user.id
      item.save
      duplicate_item = build(:item, title: item.title, user: user_2)
      expect(duplicate_item.save).to be true
    end

    it "rejects duplicate title from same user" do
      item.user_id = user.id
      item.save
      duplicate_item = build(:item, title: item.title, user: user)
      expect(duplicate_item.save).to be false
    end

    it "rejects blank url" do
      item.url = ""
      expect(item).to be_invalid
    end

    it "accepts duplicate url from different user" do
      item.user_id = user.id
      item.save
      duplicate_item = build(:item, url: item.url, user: user_2)
      expect(duplicate_item.save).to be true 
    end

    it "rejects duplicate url from same user" do
      item.user_id = user.id
      item.save
      duplicate_item = build(:item, title: item.title, user: user)
      expect(duplicate_item.save).to be false
    end

  end
end
