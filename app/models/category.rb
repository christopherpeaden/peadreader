class Category < ActiveRecord::Base
  belongs_to :user
  has_many :categorizations, dependent: :destroy
  has_many :feeds, through: :categorizations

  validates :title, presence: true, uniqueness: true
end
