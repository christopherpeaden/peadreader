require 'rails_helper'

RSpec.describe User, type: :model do

    let(:user) { build(:user) }

  describe "user attributes" do

    it "has valid attributes" do
      expect(user).to be_valid
    end

    it "rejects blank user email" do
      user.email = ""
      expect(user).to_not be_valid
    end
  end

  describe "user passwords" do

    it "rejects blank passwords" do
      user.password = ""
      expect(user).to_not be_valid
    end

    it "rejects blank password_confirmation" do
      user.password_confirmation = ""
      expect(user).to_not be_valid
    end

    it "rejects password less than 8 characters" do
      user.password_confirmation = "1234567"
      user.password_confirmation = "1234567"
      expect(user).to_not be_valid
    end

    it "rejects password if not the same as password_confirmation" do
      user.password = "12345678"
      user.password_confirmation = "1234567890"
      expect(user).to_not be_valid
    end
  end

end
