Rails.application.routes.draw do
  get 'logs/index'
  get 'admin/assign'
  resources :employees, only: [:index] do
    collection do
      get 'pdf', to: "employees#pdf"
      get 'complete', to: "employees#complete"
      get 'tasks', to: "employees#tasks"
      get 'projects', to: "employees#projects"
      get 'active_projects', to: "employees#active_projects"
      get 'completed_projects', to: "employees#completed_projects"
    end
  end
  devise_for :users
  resources :users, except: [:create] do
    collection do
      get 'admins', to: 'users#admins'
    end
    member do
      get 'profile', to: 'users#profile'
      get 'projects', to: 'users#projects'
      get 'tasks', to: 'users#tasks'
      get 'logs'
    end
  end
  post 'new_user/', to: 'users#create'
  resources :projects do
    collection do
      get 'all'
    end
    resources :tasks do
      member do
        get 'assign'
        get 'logs'
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "projects#index"
end
