require 'rails_helper'

RSpec.describe Item do

  describe "validation" do

    subject { build(:item) }
    let(:item) { subject }

    it { should be_valid }

    it "rejects blank title" do
      item.title = ""
      expect(item).to_not be_valid
    end

    it "rejects blank url" do
      item.url = ""
      expect(item).to_not be_valid
    end
  end

  describe "associations" do
    it { should respond_to(:feed) }
  end

end
