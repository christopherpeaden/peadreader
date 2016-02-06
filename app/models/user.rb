class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,          
         :recoverable, :rememberable, :trackable, :validatable,
         omniauth_providers: [:google_oauth2]

  has_many :feeds, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :youtube_channels, dependent: :destroy

  def self.from_omniauth(auth_hash)
    data = auth_hash.info
    user = User.where(provider: auth_hash["provider"], uid: auth_hash["uid"]).first_or_create
    user.update(name: data["name"], 
                email: data["email"], 
                first_name: data["first_name"], 
                last_name: data["last_name"], 
                image: data["image"],
                access_token: auth_hash["credentials"]["token"],
                refresh_token: auth_hash["credentials"]["refresh_token"])
    user
  end

  def self.new_with_session(params, session)
    if session["devise.google_data"]
      new(session["devise.google_data"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end
end
