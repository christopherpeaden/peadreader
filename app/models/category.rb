class Category < ActiveRecord::Base
  belongs_to :user
  has_many :categorizations, dependent: :destroy
  has_many :itemizations, dependent: :destroy
  has_many :feeds, through: :categorizations
  has_many :items, through: :itemizations

  validates :title, presence: true, uniqueness: true
end
