Rails.application.routes.draw do
  devise_for :users
  root 'feeds#feed_items'
  resources :feeds
end
