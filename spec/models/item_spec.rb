require 'rails_helper'

RSpec.describe Item do

  describe "messages" do
    it { should respond_to(:id) }
    it { should respond_to(:title) }
    it { should respond_to(:url) }
    it { should respond_to(:published) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe "validation" do

    subject { build(:item) }
    let(:item) { subject }

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
