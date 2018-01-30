Rails.application.routes.draw do
  devise_for :users, path_names: {sign_in: 'login', sign_out: 'logout'}

  resources :courses, except: [:edit, :update, :new] do
    get 'summary', to: 'courses#summary', as: :summary
    resources :students do
      resources :test_results
    end
    resources :tests
  end

  authenticated :user do
    root to: 'courses#index', as: :authenticated_root
  end

  root to: redirect('/users/login')
end
