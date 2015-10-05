require 'rails_helper'

RSpec.describe Category do

  describe "messages" do
    it {should respond_to(:id) }
    it {should respond_to(:title) }
    it {should respond_to(:created_at) }
    it {should respond_to(:updated_at) }
  end

  describe "validation" do

    subject { build(:category) }
    let(:category) { subject }

    it { should be_valid }

    it "rejects blank title" do
      category.title = ""
      expect(category).to_not be_valid
    end

    it "rejects duplicate title" do
      category.save
      duplicate_category = build(:category, title: category.title)
      expect(duplicate_category.save).to be false
    end
  end

  describe "associations" do
    it { should respond_to(:user) }
    it { should respond_to(:feeds) }
  end
end
