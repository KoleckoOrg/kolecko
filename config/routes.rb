Rails.application.routes.draw do
  devise_for :teams,
    path: '', path_names: {
      sign_in: 'prihlaseni',
      sign_out: 'odhlaseni',
      sign_up: 'registrace',
      edit: 'uprava_udaju'
    },
    controllers: {
      sessions: 'teams/sessions',
      registrations: 'teams/registrations'
    }

  root 'main#index'

  resources :teams, path: 'tymy'

  get '/inbox', to: 'messages#index'

  resources :visits, path: 'pruchod', only: [:index, :new, :create], path_names: {new: 'zadat'}
  get '/mapa', to: 'visits#map', as: :map

  scope(path_names: {new: 'nova', edit: 'upravit'}) do
    resources :answers, path: 'odpovedi', only: [:index, :new, :create]
    resources :puzzles, path: 'sifry', only: [:index]

    resources :hint_requests, path: 'napovedy' do
      collection do
        get :queue, path: 'fronta'
      end
      member do
        get :cancel, path: 'zrusit'
        get :answer, path: 'odpovedet', to: 'hints#new'
        post :answer, path: 'odpovedet', to: 'hints#create'
      end
    end
    resources :hints, path: 'napoveda', only: [:index, :show, :update] do
      member do
        get :accept, path: 'prijmout'
      end
    end
  end

  get '/pravidla', to: 'pages#show', as: :rules, page: 'rules'
  get '/vysledky', to: 'pages#show', as: :results, page: 'results'

  scope '/archiv/:year' do
    get '/vysledky', to: 'pages#show', as: :archive_results, page: 'results'
    get '/tymy', to: 'pages#show', as: :archive_teams, page: 'teams'
    get '/pravidla', to: 'pages#show', as: :archive_rules, page: 'rules'
    get '/sifry', to: 'pages#show', as: :archive_puzzles, page: 'puzzles'
  end
end
