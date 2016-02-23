Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks", registrations: "registrations" }

  authenticated :user do
    root 'feeds#dashboard', :as => 'authenticated_root'
  end

  devise_scope :user do
    root 'pages#landing'
  end

  resources :feeds
  resources :categories
  resources :categories, only: [:new, :create, :destroy]
  get "refresh" => "feeds#refresh"
  get "refresh_youtube" => "youtube#refresh_youtube"
  get "subscriptions" => "youtube#subscriptions"
  get "sync_subscribed_channels" => "youtube#sync_subscribed_channels"
  get "youtube_channels/:id" => "youtube_channels#show", as: "youtube_channel"
  get "test_ajax" => "feeds#test_ajax"
end
