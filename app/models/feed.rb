class Feed < ActiveRecord::Base

  validates :title, presence: true, uniqueness: true
  validates :url,   presence: true, uniqueness: true

  belongs_to :user
  belongs_to :category
  has_many :items, dependent: :destroy
end
