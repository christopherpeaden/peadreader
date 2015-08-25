Rails.application.routes.draw do
  get 'categories/new'

  devise_for :users

  authenticated :user do
    root 'feeds#dashboard', :as => 'authenticated_root'
  end

  devise_scope :user do
    root 'pages#home'
  end

  resources :feeds
  resources :categories, only: [:new, :create, :destroy]
  get "refresh" => "feeds#refresh"
end
