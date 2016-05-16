class Item < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user
  validates :title, presence: true, uniqueness: true
  validates :url,   presence: true, uniqueness: true
end
