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
                access_token: auth_hash["credentials"]["token"])

    user.update(refresh_token: auth_hash["credentials"]["refresh_token"]) if auth_hash["credentials"]["refresh_token"]

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

  def refresh_access_token
    url = "https://accounts.google.com/o/oauth2/token"

    options = {
      grant_type: "refresh_token",
      refresh_token: refresh_token,
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret
    }

    token_info = HTTParty.post(
      url,
      body: options, 
      headers: {"Content-Type" => "application/x-www-form-urlencoded"}
     )

    update(
      access_token: token_info["access_token"],
      access_token_expiration: (Time.now.to_i + token_info["expires_in"].to_i)
    )
  end

  def get_subscriptions
    url = "https://www.googleapis.com/youtube/v3/subscriptions/"

    options = {
      access_token: access_token,
      mine: "true",
      key: Rails.application.secrets.google_api_key,
      part: "snippet, contentDetails",
      maxResults: "50"
    }

    HTTParty.get(url, query: options)
  end

  def get_activities
    url = "https://www.googleapis.com/youtube/v3/activities/"

    options = {
      part: "contentDetails",
      key: Rails.application.secrets.google_api_key,
      access_token: access_token,
      home: "true",
      maxResults: 50
    }

    HTTParty.get(url, query: options)
  end
end
