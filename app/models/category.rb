class Category < ActiveRecord::Base
  has_many :feeds

  validates :title, presence: true, uniqueness: true
end
