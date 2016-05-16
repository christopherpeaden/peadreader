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
  get "refresh_feeds" => "feeds#refresh_feeds"
  get "refresh_youtube" => "youtube#refresh_youtube"
  get "subscriptions" => "youtube#subscriptions"
  get "sync_subscribed_channels" => "youtube#sync_subscribed_channels"
  get "youtube_channels/:id" => "youtube_channels#show", as: "youtube_channel"
  get "check_for_newest_items" => "feeds#check_for_newest_items"
  get "check_for_newest_videos" => "youtube#check_for_newest_videos"
  get "new_opml_import" => "feeds#new_opml_import"
  get "add_to_favorites" => "items#add_to_favorites"
  get "save_for_later" => "items#save_for_later"
  get "favorites" => "items#favorites"
  get "saved_for_later" => "items#saved_for_later"
  get "remove_from_saved_for_later" => "items#remove_from_saved_for_later"
  get "remove_from_favorites" => "items#remove_from_favorites"
  post "create_opml_import" => "feeds#create_opml_import"
end
