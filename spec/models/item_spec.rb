require 'rails_helper'

RSpec.describe Item do

  describe "validation" do

    let(:item) { build(:item) }

    it { should be_valid }

    it "rejects blank title" do
      item.title = ""
      expect(item).to_not be_valid
    end

    it "rejects duplicate title" do
      item.save
      duplicate_item = build(:item, title: item.title)
      expect(duplicate_item.save).to be false
    end

    it "rejects blank url" do
      item.url = ""
      expect(item).to_not be_valid
    end

    it "rejects duplicate url" do
      item.save
      duplicate_item = build(:item, url: item.url)
      expect(duplicate_item.save).to be false
    end
  end

  describe "associations" do
    it { should respond_to(:feed) }
  end
end
