Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'feeds#dashboard', :as => 'authenticated_root'
  end

  devise_scope :user do
    root 'pages#home'
  end

  resources :feeds
  get "refresh" => "feeds#refresh"
end
