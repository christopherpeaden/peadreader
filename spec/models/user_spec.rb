require 'rails_helper'

RSpec.describe User do

  subject { build(:user) }
  let(:user) { subject}

  describe "messages" do
    it { should respond_to(:id) }
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:encrypted_password) }
    it { should respond_to(:current_sign_in_ip) }
    it { should respond_to(:current_sign_in_at) }
    it { should respond_to(:last_sign_in_ip) }
    it { should respond_to(:last_sign_in_at) }
    it { should respond_to(:reset_password_token) }
    it { should respond_to(:reset_password_sent_at) }
    it { should respond_to(:sign_in_count) }
    it { should respond_to(:remember_created_at) }
    it { should respond_to(:password_confirmation) }
  end

  describe "associations" do
    it { should respond_to(:feeds) }
    it { should respond_to(:categories) }
    it { should respond_to(:items) }
  end

  describe "validations" do
    it { should be_valid }

    it "rejects blank email" do
      user.email = ""
      expect(user).to be_invalid
    end

    it "rejects duplicate email" do
      user.save
      duplicate_user = build(:user, email: user.email)
      expect(duplicate_user.save).to be false
    end

    it "rejects blank password" do
      user.password = ""
      expect(user).to be_invalid
    end

    it "rejects blank password confirmation" do
      user.password_confirmation = ""
      expect(user).to be_invalid
    end

    it "rejects password less than 8 characters" do
      user.password = "1234567"
      user.password_confirmation = "1234567"
      expect(user).to be_invalid
    end

    it "rejects password if not equal to password_confirmation" do
      user.password = "12345678"
      user.password_confirmation = "1234567890"
      expect(user).to be_invalid
    end
  end
end
