Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'feeds#feed_items', :as => 'authenticated_root'
  end

  devise_scope :user do
    root 'devise/sessions#new'
  end

  resources :feeds
end
