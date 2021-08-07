Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth',controllers: {
    registrations: 'auth/registrations',
  }
  namespace 'api' do
    namespace 'v1' do
      resources :events do
        member do
          get 'own'
          get 'history'
          post 'detail'
          post 'cancel'
        end
        collection do
          post 'search'
        end
      end
      resources :reserves do
        member do
          get 'events'
          get 'history'
          post 'event'
          post 'cancel'
        end
      end
      resources :users
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
