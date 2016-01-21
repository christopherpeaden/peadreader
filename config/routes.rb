Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

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
end
