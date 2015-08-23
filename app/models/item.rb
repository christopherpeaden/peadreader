class Item < ActiveRecord::Base
  belongs_to :feed
  validates :title, presence: true, uniqueness: true
  validates :url,   presence: true, uniqueness: true
end
