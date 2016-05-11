class Category < ActiveRecord::Base
  belongs_to :user
  has_many :categorizations
  has_many :feeds, through: :categorizations

  validates :title, presence: true, uniqueness: true
end
