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

  concern :pinnable do |options|
    post 'pin', action: :create, controller: options[:controller], on: :member
    delete 'pin', action: :destroy, controller: options[:controller], on: :member
  end

  scope "(:locale)", locale: /#{ I18n.locales.join("|")}/ do
    devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

    get 'notifications/all', to: 'notifications#all', as: :all_notifications
    get 'notifications/unread', to: 'notifications#unread', as: :unread_notifications
    post 'notifications/read', to: 'notifications#read', as: :read_notifications

    get 'home', to: 'courses#index', as: :home
    resources :courses, except: [:edit, :update, :new] do
      get 'summary(/page/:page)', to: 'courses_summary#show', on: :member, as: :summary
      resources :students, except: [:show], concerns: :paginatable

      resources :tests, except: [:show], concerns: :paginatable do
        get 'califications', to: 'califications#show', on: :member
        put 'califications', to: 'califications#update', on: :member
        get 'edit_califications', to: 'califications#edit', on: :member
      end

      resources :posts, shallow: true do
        get 'search/(:q)', to: 'posts_search#index', on: :collection, as: 'search'
        concerns :paginatable
        concerns :pinnable, controller: 'posts_sticky'
        concerns :likeable, controller: 'posts_likes'
        concerns :dislikeable, controller: 'posts_dislikes'
        concerns :subscribable, controller: 'posts_subscriptions'

        resources :replies, shallow: true do
          concerns :paginatable
          concerns :likeable, controller: 'replies_likes'
          concerns :dislikeable, controller: 'replies_dislikes'
          post 'select_best', to: 'best_replies#create', on: :member
          delete 'select_best', to: 'best_replies#destroy', on: :member
        end
      end
    end
  end

  authenticated :user do
    root to: redirect("/home"), as: :authenticated_root
  end

  root to: redirect("/users/login")
end