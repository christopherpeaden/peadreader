class Category < ActiveRecord::Base
  belongs_to :user
  has_many :feeds

  validates :title, presence: true, uniqueness: true
end
