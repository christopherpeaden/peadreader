require 'rails_helper'

RSpec.describe Item do

  subject { build(:item) }
  let(:item) { subject }

  describe "messages" do
    it { should respond_to(:id) }
    it { should respond_to(:title) }
    it { should respond_to(:favorite) }
    it { should respond_to(:saved_for_later) }
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

    it "rejects duplicate title" do
      item.save
      duplicate_item = build(:item, title: item.title)
      expect(duplicate_item.save).to be false
    end

    it "rejects blank url" do
      item.url = ""
      expect(item).to be_invalid
    end

    it "rejects duplicate url" do
      item.save
      duplicate_item = build(:item, url: item.url)
      expect(duplicate_item.save).to be false
    end
  end
end
