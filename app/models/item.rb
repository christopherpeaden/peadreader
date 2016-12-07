class Item < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user
  has_many :itemizations
  has_many :categories, through: :itemizations
  validates :title, presence: true, uniqueness: true
  validates :url,   presence: true, uniqueness: true
end
