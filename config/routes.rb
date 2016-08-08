Rails.application.routes.draw do

  # get 'users_join_projects/index'
  #
  # get 'users_join_projects/new'
  #
  # get 'users_join_projects/create'
  #
  # get 'users_join_projects/save'
  #
  # get 'users_join_projects/delete'

  # get 'projects/index'
  #
  # get 'projects/new'
  #
  # get 'projects/create'
  #
  # get 'projects/update'
  #
  # get 'projects/destroy'

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

  # sessions routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # routes from did_that
  resources :projects do
    resources :user_join_projects
    resources :photos
  end

  resources :user_join_projects, only: [:index]

end
