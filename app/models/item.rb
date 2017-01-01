class Item < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user
  has_many :itemizations
  has_many :categories, through: :itemizations
  validates :title, presence: true, uniqueness: { :scope => :user_id }
  validates :url,   presence: true, uniqueness: { :scope => :user_id }
end
