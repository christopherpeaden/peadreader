Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks", registrations: "registrations" }

  authenticated :user do
    root 'items#index', :as => 'authenticated_root'
  end

  devise_scope :user do
    root 'pages#landing'
  end

  resources :feeds
  resources :categories
  resources :categories, only: [:new, :create, :destroy]
  get "new_opml_import" => "feeds#new_opml_import"
  post "create_opml_import" => "feeds#create_opml_import"

  mount ActionCable.server => '/cable'
end
