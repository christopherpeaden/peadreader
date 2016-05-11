class Feed < ActiveRecord::Base
  belongs_to :user
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :items, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :url,   presence: true, uniqueness: true
end
