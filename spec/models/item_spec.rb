require 'rails_helper'

RSpec.describe Item, type: :model do

  let(:item) { build(:item) }

  describe "validations" do

    it "is valid" do
      expect(item).to be_valid
    end
  end

  describe "associations" do

    it "belongs to feed" do
      expect(item).to respond_to(:feed)
    end
  end

end
