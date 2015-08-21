class Feed < ActiveRecord::Base
  validates :title, presence: true
  validates :url, presence: true

  belongs_to :user
  has_many :items, dependent: :destroy

end
