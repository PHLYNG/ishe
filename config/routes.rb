Rails.application.routes.draw do
  # static routes
  root 'static_pages#home'
  get 'static_pages/home'
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # user and signup routes
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users do
    resources :user_join_projects
  end

  # OmniAuth route
  get '/auth/:provider/callback', to: 'sessions#create'

  # sessions routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # OSM route, on map show page and make get_map action in proj controller
  # get '/projects/:id', to: 'projects#get_map'

  # routes from did_that
  resources :projects do
    resources :project_comments
    resources :user_join_projects
  end

  resources :user_join_projects, only: [:index]

end
