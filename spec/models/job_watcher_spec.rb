require 'rails_helper'

RSpec.describe JobWatcher, type: :model do
  describe "validations" do
    it "is valid" do
      job_watcher = JobWatcher.new
      expect(job_watcher).to be_valid
    end
  end

  describe "associations" do
    it "belongs to user" do
      job_watcher = JobWatcher.new
      expect(job_watcher).to respond_to (:user)
    end
  end
end
