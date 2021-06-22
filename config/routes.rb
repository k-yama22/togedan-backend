Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth',controllers: {
    registrations: 'auth/registrations',
  }
  namespace 'api' do
    namespace 'v1' do
      resources :events
      resources :reserves
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
