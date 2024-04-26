Rails.application.routes.draw do
  root to: "posts#index"
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }, skip: [:registrations]
  devise_scope :user do
    get 'users/sign_up', to: 'users/registrations#new', as: :new_user_registration
    post 'users', to: 'users/registrations#create', as: :user_registration
    get 'users/edit', to: 'users/registrations#edit', as: :edit_user_registration
    put 'users', to: 'users/registrations#update'
    patch 'users', to: 'users/registrations#update'
    delete 'users', to: 'users/registrations#destroy'
  end
  resources :posts do
    post 'create_txt', on: :collection
    resources :tags
    resources :comments
  end
  delete "posts", to: "posts#destroy", as: :delete_post
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live
  # Defines the root path route ("/")
  # root "posts#index"
end
