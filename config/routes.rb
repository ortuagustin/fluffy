Rails.application.routes.draw do
  devise_for :users, path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'}

  resources :courses, except: [:edit, :update, :new] do
    get 'summary', to: 'courses#summary', as: :summary
    resources :students, except: [:show]

    resources :tests, except: [:show] do
      get 'results', to: 'test_results#show', on: :member
      get 'load_results', to: 'test_results#load', on: :member
      put 'results', to: 'test_results#store', on: :member
    end
  end

  authenticated :user do
    root to: 'courses#index', as: :authenticated_root
  end

  root to: redirect('/users/login')
end
