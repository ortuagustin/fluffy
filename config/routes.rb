Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  concern :likeable do |options|
    post 'like', action: :create, controller: options[:controller], on: :member
    delete 'like', action: :destroy, controller: options[:controller], on: :member
  end

  concern :dislikeable do |options|
    post 'dislike', action: :create, controller: options[:controller], on: :member
    delete 'dislike', action: :destroy, controller: options[:controller], on: :member
  end

  concern :subscribable do |options|
    post 'subscribe', action: :create, controller: options[:controller], on: :member
    delete 'subscribe', action: :destroy, controller: options[:controller], on: :member
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
        concerns :likeable, controller: 'posts_likes'
        concerns :dislikeable, controller: 'posts_dislikes'

        shallow do
          concerns :subscribable, controller: 'posts_subscriptions'
        end

        resources :replies, only: [:create, :update, :destroy], concerns: :paginatable do
          concerns :likeable, controller: 'replies_likes'
          concerns :dislikeable, controller: 'replies_dislikes'

          shallow do
            post 'select_best', to: 'best_replies#create', on: :member
            delete 'select_best', to: 'best_replies#destroy', on: :member
          end
        end
      end
    end
  end

  authenticated :user do
    root to: redirect("/home"), as: :authenticated_root
  end

  root to: redirect("/users/login")
end