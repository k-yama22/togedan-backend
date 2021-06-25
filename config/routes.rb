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
        end
      end
      resources :reserves do
        member do
          get 'events'
        end
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
