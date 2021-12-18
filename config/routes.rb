Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :feedbacks, only: [:create]
      resources :posts, only: [:create] do
        member do
          post :rate
        end
        collection do
          get :top_posts
          get :ip_listing
        end
      end
    end
  end
end
