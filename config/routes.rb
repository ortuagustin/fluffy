Rails.application.routes.draw do
  devise_for :users, path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'}

  resources :courses, except: [:edit, :update, :new] do
    get 'summary', to: 'courses#summary', as: :summary
    resources :students, except: [:show]

    resources :tests, except: [:show] do
      get 'califications', to: 'califications#show', on: :member
      put 'califications', to: 'califications#update', on: :member
      get 'edit_califications', to: 'califications#edit', on: :member
    end
  end

  authenticated :user do
    root to: 'courses#index', as: :authenticated_root
  end

  root to: redirect('/users/login')
end
