require 'rails_helper'

RSpec.describe User do

  describe "validation" do

    subject { build(:user) }
    let(:user) { subject }

    it { should be_valid }

    it "rejects blank email" do
      user.email = ""
      expect(user).to_not be_valid
    end

    it "rejects blank password" do
      user.password = ""
      expect(user).to_not be_valid
    end

    it "rejects blank password confirmation" do
      user.password_confirmation = ""
      expect(user).to_not be_valid
    end

    it "rejects password less than 8 characters" do
      user.password = "1234567"
      user.password_confirmation = "1234567"
      expect(user).to_not be_valid
    end

    it "rejects password if not equal to password_confirmation" do
      user.password = "12345678"
      user.password_confirmation = "1234567890"
      expect(user).to_not be_valid
    end
  end

  describe "associations" do
    it { should respond_to(:feeds) }
  end
end
