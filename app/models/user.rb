class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,          
         :recoverable, :rememberable, :trackable, :validatable,
         omniauth_providers: [:google_oauth2]

  has_many :feeds, dependent: :destroy
  has_many :categories, dependent: :destroy

  def self.from_omniauth(auth_hash)
    data = auth_hash.info
    user = User.where(email: data["email"]).first

    unless user
      user = User.create(name: data["name"], email: data["email"])
    end
    user
  end
end
