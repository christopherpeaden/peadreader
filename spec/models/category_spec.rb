require 'rails_helper'

RSpec.describe Category do

  describe "validation" do

    subject { build(:category) }
    let(:category) { subject }

    it { should be_valid }

    it "rejects blank title" do
      category.title = ""
      expect(category).to_not be_valid
    end
  end

  describe "associations" do
    it { should respond_to(:user) }
    it { should respond_to(:feeds) }
  end
end
