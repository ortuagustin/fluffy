Rails.application.routes.draw do
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'}

    get 'home', to: 'courses#index', as: :home
    resources :courses, except: [:edit, :update, :new] do
      get 'summary', to: 'courses#summary', on: :member, as: :summary
      resources :students, except: [:show]

      resources :tests, except: [:show] do
        get 'califications', to: 'califications#show', on: :member
        put 'califications', to: 'califications#update', on: :member
        get 'edit_califications', to: 'califications#edit', on: :member
      end
    end
  end

  authenticated :user do
    root to: redirect("#{I18n.locale}/home/"), as: :authenticated_root
  end

  root to: redirect("#{I18n.locale}/users/login")

  get '/*path', to: redirect("/#{I18n.default_locale}/%{path}"),
    constraints: lambda { |req| I18n.available_locales.none? { |locale| req.path.starts_with? locale.to_s } }
end