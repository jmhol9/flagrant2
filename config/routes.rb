Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:new, :create, :show, :index] do
    collection do
      get 'scoreboard'
    end
  end

  resource :session, only: [:new, :create, :destroy]

  # splash page
  resources :statics, only:[:index]

  # organization stuff
  resources :tournaments, only: [:index, :show]
  resources :entries, only: [:create]

  root to: 'statics#index'
end
