Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks", registrations: "registrations" }

  authenticated :user do
    root 'feeds#dashboard', :as => 'authenticated_root'
  end

  devise_scope :user do
    root 'pages#home'
  end

  resources :feeds
  resources :categories
  resources :categories, only: [:new, :create, :destroy]
  get "refresh" => "feeds#refresh"
  get "refresh_access_token" => "youtube#refresh_access_token"
  get "refresh_youtube" => "youtube#refresh"
  get "subscriptions" => "youtube#subscriptions"
  get "sync_subscribed_channels" => "youtube#sync_subscribed_channels"
end
