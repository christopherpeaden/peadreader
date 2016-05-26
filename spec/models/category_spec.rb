require 'rails_helper'

RSpec.describe Category do

  subject { build(:category) }
  let(:category) { subject }

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

    it "rejects duplicate title" do
      category.save
      dup_category = build(:category, title: category.title)
      expect(dup_category.save).to be false
    end
  end
end
