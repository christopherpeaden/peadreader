require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:category) { build(:category) }

  describe "category attributes" do

    it "has valid attributes" do
      expect(category).to be_valid
    end

    it "rejects blank title" do
      category.title = ""
      expect(category).to_not be_valid
    end

  end
end
