Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  scope "(:locale)", locale: /#{ I18n.locales.join("|")}/ do
    devise_for :users, path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'}

    get 'home', to: 'courses#index', as: :home
    resources :courses, except: [:edit, :update, :new] do
      get 'summary(/page/:page)', to: 'courses_summary#show', on: :member, as: :summary
      resources :students, except: [:show], concerns: :paginatable

      resources :tests, except: [:show], concerns: :paginatable do
        get 'califications', to: 'califications#show', on: :member
        put 'califications', to: 'califications#update', on: :member
        get 'edit_califications', to: 'califications#edit', on: :member
      end

      resources :posts, concerns: :paginatable do
        post 'like', to: 'posts_likes#create', on: :member
        delete 'like', to: 'posts_likes#destroy', on: :member
        post 'dislike', to: 'posts_dislikes#create', on: :member
        delete 'dislike', to: 'posts_dislikes#destroy', on: :member

        resources :replies, only: [:create, :update, :destroy], concerns: :paginatable
      end
    end
  end

  authenticated :user do
    root to: redirect("/home"), as: :authenticated_root
  end

  root to: redirect("/users/login")
end